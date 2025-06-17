import csv
import Draft
import Part
import Mesh
import MeshPart
import os
from BOPTools import BOPFeatures

# coil directory
cur_dir = os.path.dirname(os.path.abspath(__file__))
coil_dir = cur_dir+"/../COILS/"

# selected coils
coils = list(range(32))

# create output directory
os.makedirs(cur_dir+"/stl", exist_ok=True)

# mesh precision
ld = 0.3    # [mm]
ad = 0.6    # [rad]

__gobjs__ = []
doc = App.newDocument()
for coil in coils:
    wire_radius = 0.5 # [mm]
    __objs__ = []
    __lbls__ = []
    __xlbl__ = []
    __clsp__ = []

    with open(coil_dir+f"{coil}.wsd","r",encoding="utf8") as coil_file:
        tsv_reader = csv.reader(coil_file, delimiter="\t")
        pl = FreeCAD.Placement()
        points = []
        x2 = 0
        y2 = 0
        z2 = 0
        v1 = [0,0,0]
        v2 = [0,0,0]
        vPrev = [0,0,0]
        for i,row in enumerate(tsv_reader):
            (x1,y1,z1,x2,y2,z2,port) = row
            v1 = FreeCAD.Vector(float(x1)*1e3,float(y1)*1e3,float(z1)*1e3)
            v2 = FreeCAD.Vector(float(x2)*1e3,float(y2)*1e3,float(z2)*1e3)
            pl.Base = FreeCAD.Vector(float(x1)*1e3,float(y1)*1e3,float(z1)*1e3)
            points = [v1,v2]
        
            direction = v2.sub(v1)
            direction.normalize()
            
            z_axis = FreeCAD.Vector(0,0,1)
            rotation = FreeCAD.Rotation(z_axis,direction)
            if i > 0:
                direction2 = v1.sub(vPrev)
                #direction2 = direction.sub(direction2)
                crot = FreeCAD.Rotation(FreeCAD.Vector(0,0,-1),direction)
                sphere = doc.addObject('Part::Sphere','Sphere')
                sphere.Radius = wire_radius
                sphere.Placement = App.Placement(App.Vector(float(x1)*1e3,float(y1)*1e3,float(z1)*1e3),crot)
                __clsp__.append(sphere)
                __lbls__.append(sphere.Label)
            pl.Rotation = rotation

            cylinder = doc.addObject('Part::Cylinder','Cylinder')
            cylinder.Radius = wire_radius
            cylinder.Placement = App.Placement(App.Vector(float(x1)*1e3,float(y1)*1e3,float(z1)*1e3),rotation)
            cylinder.Height = (((float(x2)-float(x1))**2+(float(y2)-float(y1))**2+(float(z2)-float(z1))**2)**0.5)*1e3

            FreeCAD.ActiveDocument.recompute()
            __clsp__.append(cylinder)


            __lbls__.append(cylinder.Label)

            vPrev = v1
        '''
        doc.removeObject(__lbls__[len(__lbls__)-1])
        __lbls__.pop()
        __clsp__.pop()
        '''
        com = doc.addObject('Part::Compound','Compound')
        com.Links = __clsp__

        #bp = BOPFeatures.BOPFeatures(doc)
        #bp.make_multi_fuse(__lbls__)

        FreeCAD.ActiveDocument.recompute()
        s1 = Part.getShape(com,"")

        m1 = doc.addObject('Mesh::Feature','Mesh')
        m1.Mesh = MeshPart.meshFromShape(Shape=s1,LinearDeflection=ld,AngularDeflection=ad)
			
        __objs__.append(m1)
        __gobjs__.append(m1)

    if hasattr(Mesh, "exportOptions"):
        options = Mesh.exportOptions(u"/Users/yannicklaret/Desktop/{coil}.stl")
        Mesh.export(__objs__, cur_dir + f"/stl/{coil}.stl", options)
    else:
        Mesh.export(__objs__, cur_dir + f"/stl/{coil}.stl")

if hasattr(Mesh, "exportOptions"):
    options = Mesh.exportOptions(u"/Users/yannicklaret/Desktop/combined_coils.stl")
    Mesh.export(__gobjs__, cur_dir + f"/stl/combined_coils.stl", options)
else:
    Mesh.export(__gobjs__, cur_dir + f"/stl/combined_coils.stl")
