# OptoCoil

**OptoCoil** is a MATLAB-based framework for algorithmic optimization of receiver coil geometries in parallel MRI. It allows the programmatic creation, simulation, and evaluation of electromagnetic (EM) fields for various coil configurations and enables data-driven selection of optimized arrays for enhanced signal-to-noise ratio (SNR) performance in defined regions of interest (ROIs).

---

## 🔧 Prerequisites

### Software

- **MATLAB** (Tested on R2024b; other versions may also be compatible).
- **[MARIE](https://github.com/thanospol/MARIE)** – An open-source Volume Integral EM solver.
  - Expected directory: `OptoCoil/MARIE/marie.m`, etc.
- **CST Studio Suite** – Commercial EM solver from Dassault Systèmes (academic/commercial license required).
- **[FreeCAD](https://www.freecad.org/)** – For exporting coil models to 3D STL files.

> **Note**: Even when CST is used for simulations, MARIE must be installed for post-processing operations.

### Hardware

No strict requirements, but GPU acceleration (NVIDIA CUDA) is highly recommended to speed up EM field simulations.

---

## 🌀 Coil Generation

Coils are generated using scripts in `OptoCoil/COILS`.

To generate coils, run:

```matlab
createCoils_CM.m
```

This script will:
1. Define corner points of 2D coil shapes.
2. Subdivide them into fine segments using:

```matlab
[coilSeq2D] = subdivideCorners(cornerPoints, numSegments);
```

3. Apply 3D curvature:

```matlab
[coilSeq3D] = curveCoil(coilSeq2D, centerPoint, radius, angle);
```

4. Export MARIE-compatible wire models:

```matlab
coilSeq2Wire(coilSeq3D, name, wireDiameter, resistivity);
```

Additional functionality includes:

- Rotate coil in the XY plane:

```matlab
[coilSeq2D] = rotate2Dcoil(coilSeq2D, angle);
```

- Combine multiple coils:

```matlab
combine_coils.m
```

The default script generates 32 coil configurations stored in `OptoCoil/COILS`.

> **Note**: To generate the 420 coils from the research run `createCoils_420.m`

---

## 🧊 Phantom Creation

A cylindrical phantom (6 mm resolution) is included in `OptoCoil/FIELDS`.

While CST can be used for simulations, a phantom model must also exist in the MARIE environment to enable optimization. Follow the MARIE documentation for custom phantom creation.

---

## ⚡ EM Field Simulation

### Using MARIE

Run:

```matlab
createFields.m
```

This generates field data for all coils using the cylindrical phantom. Requires MARIE to be installed.

### Using CST

1. Open the CST macro project:

```
OptoCoil/CST/macroSegmentCoils.cst
```

2. Run the macro:

```
importMARIEwire
```

This macro:
- Segments wires
- Generates meshes
- Simulates fields
- Exports data

3. Convert exported fields to MATLAB format:

```matlab
loadFieldsCST.m
```

> ⚠️ Update CST’s history list before re-running macros to avoid errors.

---

## 🤖 Array Optimization

Run the optimization with:

```matlab
OptoCoil/OPTIMIZE/optimizeArray.m
```

This script selects 8 coils (from the default 32) using the additive-mean algorithm. Optional features:
- Adjust algorithm type
- Enable acceleration-aware performance scoring

> SNR values can be compared against the included uiSNR map (phantom only). For new models, users must calculate uiSNR independently based on available literature.

---

## 🧱 Export to STL

Generate a 3D model of coil arrays:

1. Open `OptoCoil/MISC/wire2stl.py` in FreeCAD.
2. Set coils to export:

```python
coils = [1, 2, 3]
```

3. Run the script in FreeCAD.

STL files are saved in:

```
OptoCoil/MISC/stl
```

---

## 📎 Repository

All code and documentation are hosted on GitHub:

🔗 [https://github.com/YLaret/OptoCoil](https://github.com/YLaret/OptoCoil)

---

## 📝 License

This project is licensed under the **GNU General Public License v3.0**. See the [LICENSE](LICENSE) file for details.

---

## 📚 Citation

Please cite relevant papers (e.g., MARIE, uiSNR methods) when using or modifying this codebase in academic work.
