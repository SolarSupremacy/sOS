# Solar Operating System (sOS) - 0.1
The ASCII operating system nobody asked for.

Join us on Discord! https://discord.gg/fpTu8Eb

# What is sOS?
sOS is a simulation of a text-based OS written in Lua with the help of LÖVE 2D. Apps can also be loaded, allowing you to develop or download anything you can imagine and run it in sOS! This is completely safe for you as a user to download random lua scripts on the internet and throw them in /programs/ because all apps are loaded in a sandboxed environment. The apps only get access to math functions, the sOS api, and a few other utilities.

# How to run sOS
You need to have LOVE 2D installed to run sOS. If you have ZeroBrane IDE installed, you can open sOS as a project, go to Project > Lua Interpreter and set it to LOVE, then use F6 to execute. Otherwise, drag the *folder* that sOS is in onto 'love.exe'.

# New Version News - 0.1
0.1 is our first major-ish milestone. It feels weird calling it that because sOS is still a buggy-as-hell text based pseudo operating system written in Lua, but it's here. Apps can now be loaded, closed, we have a new and slightly more optimised method of rendering. Now, you have one app which is pretty much fullscreened in the middle of the screen and a sidebar on each side displaying current running apps and other system information. We've got a long way to go, but for a project that started less than a week ago (yeah, I know... o_O) we've made it pretty far.

Stay tuned!

# Controls

*On the Left...*

**Tab** (or **Shift + Tab**) cycles through open apps. Even when apps are open, you can cycle through the 'no app' entry, making all apps run in the background.

**Escape** closes the currentlty selected app. If no app is selected (described above), Escape closes sOS.

*On the Right...*

**Page Up** and **Page Down** cycle through the apps detected. The selected app has a '>' next to it.

**End** switches between selecting system apps (on the top) and user apps (on the bottom).

**Home** starts a new process with the app selected.

# App Development Documentation
App development uses S-Code, which is just an easier way of saying environment-limited Lua with sOS api. The link for the setup for the sandbox environment is here: https://hastebin.com/acolabiqez.lua You may use any Lua functions included in there, including the api functions at the bottom. This page will be updated as more features are implimented.

# API.G - Graphics
> api.g.set(x, y, char)

Inputs: 'x' and 'y' are the coordinates for the character, with (1, 1) being the top left. 'char' should be a single character.

Result: 'char' is put onto that coordinate on the canvas to be rendered in the next draw(). Use in draw().

Return: true

> api.g.get(x, y)

Inputs: 'x' and 'y' are the coordinates for the character, with (1, 1) being the top left.

Result: Fetches the char at that coordinate from the last draw(). Use in tick().

Return: string

> api.g.text(x, y, str)

Inputs: 'x' and 'y' are the coordinates for the start of the string, with (1, 1) being the top left. 'str' should be a string of one or more characters.

Result: 'str' is put onto that coordinate on the canvas to be rendered in the next draw(). Use in draw().

Return: true

> api.g.box(x, y, w, h, adapt)

Inputs: 'x' and 'y' are the coordinates for the start of the box, with (1, 1) being the top left. 'w' and 'h' are the width and height of the outside of the box, so the inside is 2 units less on each dimension. 'adapt' is a boolean for if the edges and corners of the box being drawn should automatically reformat to make grids or intersecting lines instead of overwriting the edges of other boxes.

Result: Draws a rectangle out of ASCII characters. Adapt has special effects described above.

Return: true

# API.I - Input
> api.i.keyStat(key)

Inputs: 'key' is a string for the name of the key to be checked. For example, "a", "shift", "space".

Result: Checks to see if the key is being pressed. Will not detect keys if not active app.

Return: true if key is pressed, false otherwise.

# API.S - System (only avaliable to system apps, which you can also develop if you wish)
> api.s.appsTable()

Inputs: Nothing.

Result: Returns (a deep copy of) the table of apps. This is a bit more complicated and will be documented on the wiki later.

Return: apps (Table)

# Called Functions
The following functions are called by sOS. This is also the order in which they are called, so code accordingly.

> load()

Called once on load. Should contain information about the app.

> textInput(char)

Optional. 'char' is a character typed and formatted correctly. For example, if you hold 'shift' and hit 'a', this function will call with the argument 'A'. Useful for easy typing.

> keyPress(key, rep)

Optional. 'key' is the name of a key. 'rep' is if the call is because of the key being repeated without releasing it, just like if you hold a key in a chat box and it types one letter, pauses, and then repeats that character. This is defined by your actual operating system and can be ignored by ignoring the call if 'rep' is true.

> keyRelease(key)

Optional. 'key' is the name of a key. This function is called if a key is released.

> tick()

Called every tick. Still has access to last cycle's canvas, so api.g.get() will still work.

*The canvas is reset after tick() and before draw().*

> draw(width, height)

Called after every tick. Now is the time to draw things onto the canvas to display. 'width' and 'height' are arguments for the current canvas width and height.

# App Template and Other Information

This is a template: https://hastebin.com/iqukigiril.lua
It doesn't do anything but set up the app.

The app must start with 'local app = {}' and end with 'return (app)'.
All functions must start with 'app.', such as 'app.load()' or 'app.customFunction()'.

Apps must be placed into the /programs/ folder of sOS. They will be automatically be detected.
