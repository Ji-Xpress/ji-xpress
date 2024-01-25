## Project Roadmap

The Ji-Xpress editor is useful as is, but it can always get better. There is a short term roadmap for the application. Below are some areas where it can be enhanced to become a lot better:

### Game Packs

* The ability to load packs from `.pck` files, as detailed in [the documentation](https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html). This will allow the product to work as a standalone binary and work with code in PCK files, and export those into proper projects.

### Exporting

* The ability to export projects into standalone game binaries or executables on various platforms, including Windows, Mac, Linux, Android, iOS and Web.

### Coding

* Implement custom coding environments for objects within the scope of a scene. This will extend the current code executed at object level, and complement it with code executed within scenes.
* Enhance the Graph Editor to be more flexible, for instance:
    * The ability to delete multiple nodes.
    * The ability to easily change the connection between nodes without deleting nodes.

### Optimization

* The current code execution model is run using a simple algorithm. For efficiency, we can instead compile the visual model into GDScript (at run time or at build time - this is when exporting the project) - and execute the GDScript instead.

### User Experience

The user experience can always improve. Ideas are welcome for this.