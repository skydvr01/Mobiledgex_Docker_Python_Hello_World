# MobiledgeX_Docker_Python_Hello_World

This demo application walks through the following
* Step 1 -- How to create a base level Python http server that serves up a bare bones index.html and view from local browser
* Step 2 -- How to "dockerize" the webserver and view from local browser
* Step 3 -- How to deploy the "dockerized container" to the MobiledgeX platform and view from local browser

Couple of requirements:
* This tutorial was developed for Mac OSX
* Install Python 3 and Git -- https://nodejs.org/en/download/ && https://githowto.com/

## Step 1 -- Create a Basic Web Server and View from Local Browser

Step 1a -- Open a terminal window and create a temporary directory (call it anything you want)

Step 1b -- Download the sample code with Git (make sure you are in your temp directory) and then CD into the directory after downloading the github repository -- Type the following command into your terminal:
```
git clone https://github.com/skydvr01/Mobiledgex_Docker_Python_Hello_World.git
```
Step 1d -- Verify that the same files you see on the Github repository webpage are the same files you see in the local directory. Your local directory should look like this.
```
ls
```

Step 1e -- Start the Python3 http-server server  
```
python3 -m http.server 8000
```

Step 1g -- open "http://localhost:8000" in a browser. You should see this <show image> in a new browser window. Congratulations! You started a Python webserver and served up index.html! 

## Step 2 -- Dockerize Your Website and View from Local Browser

Step 2a -- Build the docker image (don't forget the period at the end of this command!)
```
docker image build -t pytest:1.0 .
```
Step 2b -- Run the docker image you just created
```
docker container run --publish 8000:8010 --detach pytest:1.0
```
* "publish 8010:8000" -- This tells docker to forward traffic incoming on the host’s port 8000 (your computer), to the container’s port 8010 (containers have their own private set of ports, so if we want to reach one from the network, we have to forward traffic to it in this way; otherwise, firewall rules will prevent all network traffic from reaching your container, as a default security posture).
* "detach" --Tells Docker to run this container in the background so that you don't have to open a new terminal window

Step 2c -- Type "localhost:8010" into a new browser window and you should see [this](). Congrats! You have just dockerized a Python Webserver!

BONUS POINTS -- Type the following into your terminal and you should see index.html printed out in your terminal window. The "curl" command is a faster way to test your website without having to leave the terminal window!
```
curl localhost:8010
```

## Step 3 -- Deploy the "dockerized container" to the MobiledgeX platform and View from Local Browser
Step 3a -- Log into https://console.mobiledgex.net/. If you do not have an account or are not provided one, please speak to the event organizer, email support@, or create an account. Once you are able to login, do the following:
* Click on the right box that says "MobiledgeX Compute" 
* Click on the "Organizations" tab on the left nav
* Click on the green button at the top that says "new"
* In Step 1 (Create your organization), for "TYPE," select "Developer", and then fill out ORGANIZATION NAME, address, and phone. Then click CREATE ORGANIZATION.
* NOTE -- Remember ORGANIZATION NAME. This is important for future steps and affects our system file path for your container image. 
* In Step 2 (Add User), fill out Username, Organization name, and for Role, select "Manager" 
* For "Role" on the second step, select "Manager" and then click "Move to Step 3" and you are done creating an organization.

Step 3b -- Open a terminal and type the following command. This should list the docker image you just created from the steps above 
```
docker image ls
```

Step 3c -- Log into the MobiledgeX Platform
```
docker login -u <your_user_name__remember_it_is_not_your_email> docker.mobiledgex.com
```

Step 3d -- "Tag" your image with a simple name that you can reference later. I named my container "hello_world:1.0" in lower case. You can see [how this container shows up](https://drive.google.com/file/d/1GGMt6rb5vTtvAi1YfuFB8Gwvs2UkkKav/view?usp=sharing) when I type "docker image ls" in the terminal. 
⋅⋅* REMEMBER your application name and version number

```
docker tag <(your application name):(version number)> docker.mobiledgex.net/<your organization name from earlier>/images/<application name>:<version>
```

Step 3e -- Push your image to the MobiledgeX Docker Repository
```
docker push docker.mobiledgex.net/<your organization name from earlier>/images/<application name>:<version>
```
Step 3f -- Log out of your MobiledgeX session
```
docker logout docker.mobiledgex.net
```

Step 3g -- Deploy your backend to a live cloudlet
* Pull up or login to the MobiledgeX console https://console.mobiledgex.net/ 
* Create an "App"
⋅⋅* Click the "Apps" button in the left nav
⋅⋅* Click the green "NEW" button at the top of the screen.
⋅⋅* For REGION, select EU
⋅⋅* For APP NAME, type the same name from Step 3c
⋅⋅* For APP VERSION, type in the same name from Step 3c
⋅⋅* For IMAGE PATH, this should auto populate. Assuming what you typed for NAME and VERSION are the same as what you typed in Step 3c, this path should be fine
⋅⋅* For DEPLOYMENT TYPE, choose DOCKER
⋅⋅* For DEFAULT FLAVOR, choose "m4.small"
⋅⋅* For PORTS, type in "8000" and for SELECT PORT, choose TCP. No need to click "ADD PORT" after.
⋅⋅* NOTE -- If you get a red error message or if you do not see anything pop up after clicking CREATE, you probably typed in something incorrect in the APP NAME or APP VERSION. 

* Create a "Cluster Instance"
⋅⋅* Click the green button called "MANAGE" on the right. It should [look like this](https://drive.google.com/open?id=1QF2KzGC2tZCO2kTWJ0Ngs9Ua9y_xomK3). If you don't see the button, you need to create an organization. Go back and redo STEP 3A. Then come back here. 
⋅⋅* Click the "CLUSTER INSTANCES" in the new nav bar on the left.
⋅⋅* Click the green "NEW" button at the top of the screen. 
⋅⋅* For REGION, select EU
⋅⋅* For CLUSTER NAME, type "testcluster"
⋅⋅* For OPERATOR, select XXX -- REMEMBER THIS
⋅⋅* For CLOUDLET, select YYY -- REMEMBER THIS
⋅⋅* For DEPLOYMENT TYPE, select DOCKER
⋅⋅* For IP ACCESS, select DEDICATED 
⋅⋅* For FLAVOR, select "m4.small"
⋅⋅* Click the green "CREATE" button at the bottom to create your "Cluster Instance"

* Launch Your App!
⋅⋅* Click on APPS in the left nav bar
⋅⋅* Click on the green LAUNCH in the new main window
⋅⋅* For OPERATOR, select XXX (same as above)
⋅⋅* For CLOUDLET, select YYY (same as above)
⋅⋅* For CLUSTER INSTANCE, select "testcluster." Note that this is the same name as what you typed in the previous section
⋅⋅* Click the green "CREATE" button at the bottom to launch your app!

Step 3h -- Verify that your Hello World Website has launched
* Click on APP INSTANCES in the left nav bar. You should see [this](https://drive.google.com/open?id=1BZ37DsZ96QYxLWVqrHpKJDYfcZLHGYPi)
* Click on the instance that is displayed in the new window
* Copy out the URI. Scroll down to find the URI. It should look like [this](https://drive.google.com/file/d/1CFU-9rhCC7nkrJUPDPf06JgKYlmk9LsO/view?usp=sharing)
* Open a new browser to the <URI>:8000 and you should see your [hello world webpage](https://drive.google.com/file/d/1gHb53rEdmur1Pdibk2R0lOzDsRrtv2hx/view?usp=sharing)!

Help Tip -- Logging In -- The website, https://console.mobiledgex.net/, uses your "user name" that you created when creating an account so make sure to save this infomation along with your login/pwd, and preferably in a password manager.

Help Tip -- TRACE ID -- If you experience issues or your Docker Container does not deploy, we will ask you to let us know the "trace ID" number. To find your "trace id" number, look on the left nav for for "audit log", click on "audit log," new data should populate the three boxes within the right nav panel, find the box marked "raw viewer," scroll down to the bottom and you should see a JSON field called "trace id." Check out [this video](https://drive.google.com/open?id=1ypz_QiEbFUUhHGGqDty-DTdLCqlTUvVs) to see where to click in more detail. 

Bonus Points -- Type the following command to validate via the command line that your docker image is up and running without leaving the terminal. Your output should look like [this](https://drive.google.com/file/d/1BRLBm2D0MlPs3AWSyEK5kW--nZWOlktI/view?usp=sharing).
```
curl http://localhost:8090/
```

## Good to know Docker Commands

List all running docker containers. Output will be similar to [this]().
```
docker ps
```
Kill a specfic container. Output will be similar to [this]().
```
docker kill <containter ID>
```
List all images currently on your local machine. Output will be similar to [this](https://drive.google.com/file/d/1IfIiM2-WpjfYzUFH9NJV1ljBK-crwcu0/view?usp=sharing). Docker [documentation link](https://docs.docker.com/v17.12/edge/engine/reference/commandline/image_ls/). Relevant [stackoverflow link](https://stackoverflow.com/questions/30543409/how-to-check-if-a-docker-image-with-a-specific-tag-exist-locally)
```
docker images
```
