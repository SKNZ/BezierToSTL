# BezierToSTL
Converts Bezier curve exported from Inkscape as SVG to STL.

Made by Robin VINCENT-DELEUZE & Floran NARENJI-SHESHKALANI as a part of the Ensimag Ada course.
Main file is src/beziertostl.adb
Comments in the code are written in French due to school-related constraints.

Executables will be found in the bin folder after build (see build instructions for more information).

# Build instructions
- With gprbuild: run "gprbuild" in the root directory of the projet
- With gnatmake: run "gnat make -P BezierToSTL.gpr" in the root directory of the project

# Directories
- src: source code
- obj: build folders
- bin: runnable folder
- doc: subject + provided samples

# References
- GPR file
https://gcc.gnu.org/onlinedocs/gcc-3.3.5/gnat_ug_unx/Common-Sources-with-Different-Switches-and-Different-Output-Directories.html
- OOP
http://www.adahome.com/9X/OOP-Ada9X.html
- Enumeration IO
https://www2.adacore.com/gap-static/GNAT_Book/html/aarm/AA-A-10-10.html
- Hypot
https://en.wikipedia.org/wiki/Hypot
