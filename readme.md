# _TR WIP readme

*_TR* is a sound sources spatialization framework focused on *Trajectories* and *Reverb (or ambience)* applied to sound sources.

This repository represents a *prototype* (but a functional one) for a proposal of sound spatialization model.

Soon the code contained here will be rewritten in a more optimal technology (Open Frameworks, WxWidgets ... not defined yet).

## Usage

- Download and install [Processing 4](https://processing.org/download)
- Download and install Purr Data (not completly compatible with Pd vanilla yet)
- Downlaod the source code and rename folder as *TR*

On linux / unix
```
git clone https://github.com/casanovajose/_TR_Standalone.git
mv _TR_Standalone TR

```

- Install the required libraries (ControlP5, oscP5, netP5, codeanticode.tablet) using the processing IDE

- Add *processing-java* to path (if you don't need the Processing IDE, otherwise _TR can be executed from Processing IDE)

On linux / unix
```
export PATH=<the processing folder location>:$PATH
```
- If processing folder is in PATH you can run using the following command (unix & windows):
```
processing-java --force --sketch=<the path to the TR folder> --output=<some temporary folder> --run 
```
You can create a .sh or a .bat in order to use as executable


## The spatialization model I

*_TR* embodies a spatial model centered in musical/sound gestures. This implies that it is not necesary focused on spatial accuracy.


## The interface

## The spatial processing

The audio processing is not a task for the interface. Since the GUI only generates data could be used any software or hardware capable of use the information. The *pd* folder contains a posible implementation for *Pure Data*. The pd modules are organized in the following way:

| MODULE | FUNCTION | MAIN _PATCHES_ |
| --- | --- | --- |
| Controllers | Provide ways to control the spatial processing.| list_traj, simple\_OSC, simple\_OSC\_quad, sequencer16, simple\_OSC\_send |
| Generators | Control on sound inputs (sound sources). | soundfile~, additive~, direct~, fm\_phase~ |
| Spaces | Routing audio to speakers (stereo, quad, etc. ) | stereo\_lr\_2~, quad~ |
| Mixers | Fine tunning between direct sound and reverb | stereo\_lr\_rev~, quad\_rev~ |
| Procesors | Filters, reverbs & other effects | rev~, rev\_del\_fbk~, rev\_conv~, fil\_bp~, pitch\_shift~ |
| Miscelaneous (misc) | Test audio systems or functionalities | test\_quad~ , test\_OSC |

## The control

There are three main ways for control the sound:

### OSC

Once created or loaded a trajectory on the GUI the OSC messaging can be used to control the spatial processing in *Pure Data* (or any other system). When pressing the *play* button a OSC stream starts. Patches like simple_OSC can handle the incoming values.
### List files

The *.tr* files generated when saving a trajectory can be used directly in *Pure Data*. The *.tr* file stores the information for a trayectory points using one line per point. Each line has the following format:

~~~
< coord x > < coord y > < speed > < pressure > < command > < scene direct values > < scene reverb values >
~~~

- The first two values are the coordinates (x, y) .
- The 3rd is the speed or difference with a previous value.
- The 4rd is the tablet pressure. If no tablet is 0.
- The 5th is a *free* command. **START** and **END** indicates the begining and ending of the trajectory path or paths. These commands are useful e.g. to have more control on multipath trajectories.
- The 6th is a groups of values of which contain the spatial information of the direct sound. Each value represents the amplitud for a speciic sound output. The values are separated by spaces. e.g. A quadraphonic trajectory will use 4 values.
- The 7th is the group with the reverb value for each output.

e.g of *.tr* file for a stereo *scene*
~~~
156 147 0 START 38.82353 0 72.54902 8.235294;
162 140 6 _ 35.686275 0 74.117645 9.411765;
166 135 4 _ 33.333336 0 74.5098 10.588236;
167 135 0 _ 33.333336 0 74.5098 10.980392;
167 135 0 _ 33.333336 0 74.5098 10.980392;
167 135 0 _ 33.333336 0 74.5098 10.980392;
169 134 1 _ 32.941177 0 74.5098 11.372549;
172 131 3 _ 31.372551 0 75.29412 12.156863;
185 126 9 _ 28.627453 0 75.29412 16.078432;
189 124 3 _ 27.058825 0 75.29412 18.431374;
193 123 2 _ 26.274511 0 74.5098 21.568628;
196 123 1 _ 26.274511 0 74.5098 24.313726;
205 118 7 _ 22.352942 0 73.725494 33.72549;
207 117 1 END 21.568628 0 72.94118 36.078434;
~~~

### Live (Not implemented yet)


## The spatialization model II

### Scenes

### Sound trajectories

## Ideas for the future

- Find a propper name. *_TR* is just a prototype name suitable for a prototype.
- A better GUI with better look & feel and more functionalities.
- Take beyond the idea of using images to encode spatial information.
- Rewrite all in c++. Tentative *Open Franmeworks*  
- Supercollider implementation.
- Faust implementation.
- VST plugin   