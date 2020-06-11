
## Contributing Guidelines

- Get in touch and communicate! Let us know what you are working on or report bugs using the issues tab. Join the [Wesnoth Discord server](https://discord.gg/battleforwesnoth) to discuss the project live or to get in touch with the community. Ping @Vultraz to get access to the #project-haldric channel.

- A rough outline of things that need to be done can be found [here](https://github.com/wesnoth/haldric/issues/5).

- For code, we follow the [GDScript Style Guide](https://docs.godotengine.org/en/3.1/getting_started/scripting/gdscript/gdscript_styleguide.html). We try to write clean and self-documenting GDScript as it helps us build upon each other's work. We use static typing to write more robust code and get full auto completion in Godot 3.1. Also, we're here to review and to help you improve your code.

- The maintainers may refactor or tweak your code to make it fit the project's style, but we'll give you the opportunity to refine the style by yourself.

## New to Godot?

- If you never worked with the Godot Engine before, the [Official Godot Docs](https://docs.godotengine.org/en/3.2/index.html) will guide you through your first steps in Godot.

- If you are more a video type person, here are a few links:

    - (3.0) [Getting Started -- Godot 3](https://www.youtube.com/watch?v=hG_MgGHAX-Q) - by [Gamefromscratch](https://www.youtube.com/channel/UCr-5TdGkKszdbboXXsFZJTQ)
    - (3.0) [Learning Godot 3.0](https://www.youtube.com/watch?v=uPoLKQG0gmw&list=PLsk-HSGFjnaFutTDzgik2KMRl6W1JxFgD) - by [KidsCanCode](https://www.youtube.com/channel/UCNaPQ5uLX5iIEHUCLmfAgKg)
    - (3.1) [Intro to GDScript for Programming Beginners](https://www.youtube.com/watch?v=UcdwP1Q2UlU&t=) - by [GDQuest](https://www.youtube.com/channel/UCxboW7x0jZqFdvMdCFKTMsQ)
    - (3.1) [Intro to C# in Godot 3.1](https://www.youtube.com/watch?v=hRuUHxOCYz0&t) - by [GDQuest](https://www.youtube.com/channel/UCxboW7x0jZqFdvMdCFKTMsQ)
    - (3.2) [Godot Action RPG Series](https://www.youtube.com/playlist?list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a)

### Note: 

Haldric uses the latest stable build of the Godot Engine, currently that is 3.2.1

The Tutorials are for different 3.X versions. While there are a few differences in the API, the general concept has not changed.

However we do not reccomend watching tutorials for Godot 2.1, as the jump from 2.1 to 3.0 was quite big.

### Download Godot
Godot can be downloaded on their official [Download Page](https://godotengine.org/download) or on [Steam](https://store.steampowered.com/app/404790/Godot_Engine/)!


## How To set up the The Battle for Wesnoth 2.0 Development environment.

This quick guide will walk you through the process of setting up a standard development environment for The Battle for Wesnoth 2.0

### Step 1: Download and “Install” Godot:
Download the latest version of Godot for your Operating System from the Godot website. You will likely want the Standard 64-bit version (The Mono version adds C# support however unless you have a specific need for this the Standard version will suffice.)
![image1](https://user-images.githubusercontent.com/18131389/83956387-56f50f80-a812-11ea-98d6-cc817628704b.jpg)

The Godot executable does not require installation so you will simply need to extract the exe from the zip file to the location of your choosing.\
Once you have placed the executable in the desired location simply run it to Start Godot.\
![image2](https://user-images.githubusercontent.com/18131389/83956388-578da600-a812-11ea-95dc-847ee5d235a5.jpg)

### Step 2: Download Wesnoth repository
Obtain the current Haldric zip file from the Wesnoth Haldric Github page (https://github.com/wesnoth/haldric)
![image3](https://user-images.githubusercontent.com/18131389/83956389-578da600-a812-11ea-95f5-f5feb29fb5ed.jpg)

Open the Godot Engine and select the Import button from the right-hand menu
![image4](https://user-images.githubusercontent.com/18131389/83956390-58263c80-a812-11ea-9ac6-51ee648dd075.jpg)

Use the Browse button you navigate to the downloaded zip file.   
You will need to create an empty directory to open the project in and navigate to that directory in the “Project Installation Path:” Field. You can tell that the paths are valid by the green checkmark by each field.
![image5](https://user-images.githubusercontent.com/18131389/83956391-58263c80-a812-11ea-8b1e-d2059e68cb67.jpg)

Hit the “Import & Edit” button to load the project.\
Once Loaded you will be ready to start assisting in the development of The Battle for Wesnoth 2.0!
![image6](https://user-images.githubusercontent.com/18131389/83956392-58263c80-a812-11ea-8aaa-77c4252a461a.jpg)
