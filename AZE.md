# BoiteMaker

Creates boxes.

Made by Robin VINCENT-DELEUZE & Floran NARENJI-SHESHKALANI as a part of the Ensimag Ada course.
Main file is src/boites.adb
Comments in the code are written in French due to school-related constraints.

Executables will be found in the bin folder after build (see builder instructions for more information).

If you wish to use the --pattern option, ImageMagick is required, and should be present in your $PATH.

# Build instructions
- With gprbuild: run "gprbuild" in the root directory of the projet
- With gnatmake: run "gnat make -P BoiteMaker.gpr" in the root directory of the project

# Directories
- src: source code
- obj: build folders
- bin: runnable folder
- doc: subject + provided samples

# References
- GPR file
https://gcc.gnu.org/onlinedocs/gcc-3.3.5/gnat_ug_unx/Common-Sources-with-Different-Switches-and-Different-Output-Directories.html
- Process interaction
http://www.adacore.com/adaanswers/gems/gem-54/
https://www2.adacore.com/gap-static/GNAT_Book/html/rts/g-expect__ads.htm
