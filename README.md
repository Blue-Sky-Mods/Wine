# Wine
A wine brewing script developed by Erryial and Ellis. This is a team minigame, which best suits group sizes between 2 and 4.

# Showcase
Video here

# Installation
1. Take the 3 folders (BlueSky_Wine, BlueSky_Sounds, BlueSky_Keymaster) and put them into your fivem resources folder
2. Add below to your server.cfg
  ``` 
  start BlueSky_Wine
  start BlueSky_Sounds
  start BlueSky_Keymaster
  ```
3. Execute SQL file `BlueSky_Wine.sql` or its contents on your fiveM database. This will add 4 items to item table (highQualWine, lowQualWine, grape, water). You will likely have water in the table anyways if you have an esx install.

# Description
*  Players will have to collect two base ingrediants, which are grapes and water. We built this script on top of only the base esx scripts, so Water can be often be bought in most esx store scripts. 
* They will load these ingrediants into the wine brewing machine. 
* Then they will start the machine.
* At default configuration settings, a wine is produced every one minute. During this one minute, players must mantain the temperature and acidity level of the wine within an acceptable range. 
* While they are doing this, they must also make repairs around the facility. 
* If players are able to keep the temperature and acidity in range, while also fixing the broken parts around the facility, they will receive a fine wine. If they aren't doing as well, they just receive a basic wine. They will have to collect the wine as it accumalates. 
* When the player is done, they will head back up to the vinery and sell the wine there. 

