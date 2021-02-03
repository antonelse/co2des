# **co2des**

**_co2des_** is ...

## **Prerequisites**
This app is based on different software. To use the entire functionalities you have to install the following software:
+ [Processing](https://processing.org/)
+ [TidalCycles](https://tidalcycles.org/Welcome)
+ [Atom](https://atom.io/)

### Processing Dependencies
Before running the Processing script, you have to install ...


## **How To**
### Configure the machine
+ For the live coding part, refer to the official [installation guide](https://tidalcycles.org/Installation) to configure the [TidalCycles](https://tidalcycles.org/Welcome) environment. \
There is an "easy way" automatic script to install all the software related to this [here (macOs)](https://tidalcycles.org/MacOS_automated_installation) and [here (Win)](https://tidalcycles.org/Windows_choco_install).

+ For the visual part, you have to download [Processing](https://processing.org/download/) and simply install it.

### Configure the Atom text editor
From the coder side, the full app functionalities were tested using the [Atom](https://atom.io/) text editor.
To code in TidalCycles you need to install the official [package](https://atom.io/packages/tidalcycles) for Atom.
To use the full functionality, we had to "hack" the package.
In specific we have modified the `repl.js` file. \
On macOs `/Users/[USERNAME]/.atom/packages/tidalcycles/lib/repl.js` \
On Win `C:/Users/[USERNAME]/.atom/packages/tidalcycles/lib/repl.js`

You have to **substitute** this file with the one provided by us in the `./live coding/atom` folder, and **modify** the IP Address with the one showed on the Processing console.

**For example**, if the Processing console is like this
``` shell
### [2021/2/3 10:52:16] INFO @ OscP5 is running. you (192.168.1.224) are listening @ port 9000
```
the only thing you have to do is to copy this IP Address **from** Processing **to** the `repl.js` file. \
After this change, this file will look like this (`line 138`):
```javascript
this.myUdp.send(buf, 0, buf.length, 9000, "192.168.1.224");
```
After this operation you have to close and reopen the Atom editor. \
**NOTE.** The IP Address (i.e.`192.168.1.224`) has to be the **same**.

For more info, read the related `README.txt` in each sub-folder.

### Live coding session
Before starting the session, you have to do some preliminary operation inside the `configuration.tidal` file. After that, you can try the system by executing some lines inside the `live_session.tidal` file. \
You can find these files inside our `./livecoding/tidalcycles` folder.


## Known Issue
+ **macOs microphone permission** - [link](https://github.com/processing/processing-sound/issues/51#issuecomment-622929461)

+ **superCollider "late" messages** - [link](https://github.com/musikinformatik/SuperDirt/blob/develop/superdirt_startup.scd)


## Example Use


## Hack The System
+ change the screen size - default `1550x1000`
+ different parameter mapping - see the `configuration.tidal` file
+ code with your own samples - [here](https://tidalcycles.org/Custom_Samples)


### Authors
Antonio Giganti - [GitHub](https://github.com/antonelse) \
Carlo Pulvirenti - [GitHub](https://github.com/LoreTalone) \
Lorenzo Talone - [GitHub](https://github.com/carlopulv)

### License
This project is licensed under the GNU General Public License v3 - see `LICENSE.txt` for details.

**co2des** \
Copyright© 2021, Antonio Giganti, Carlo Pulvirenti & Lorenzo Talone.

### Useful Links

+ [TidalCycles Documentation](https://tidalcycles.org/Userbase)
+ [Live Coding Community](https://toplap.org/)
+ [Haskell Resources](https://tidalcycles.org/Haskell_resources)
+ [Awesome Live Coding List](https://github.com/toplap/awesome-livecoding/blob/master/README.md)
