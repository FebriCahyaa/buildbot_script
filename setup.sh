# Copyright (C) 2020 Jimgsey All rights reserved

# Declare all functions

## Your link server generate. For example Sourceforge: https://sourceforge.net/projects/lavender7/files
LINKSOU="https://sourceforge.net/projects/semutprjct/files/Lavender"

## Your link account to upload. For example: jim15@frs.sourceforge.net:/home/frs/project/
LINKUPL="semutimut76@frs.sourceforge.net:/home/frs/project/semutprjct/Lavender/"

## Device Default structure
DEVICES="/xiaomi/lavender"

## Folder Script (where everything is compiled) 
SCRIPT="${HOME}/Android"
## Folder Builds working
SCRIPTFOLDER="${HOME}/Android/Builds"

# Add colors
red=$(tput setaf 001)             #  red
green=$(tput setaf 002)           #  green
orange=$(tput setaf 208)          #  orange
blue=$(tput setaf 004)            #  blue
magenta=$(tput setaf 005)         #  magenta
cyan=$(tput setaf 006)            #  cyan
grey=$(tput setaf 242)            #  grey
smul=$(tput smul)                 #  smul
bold=$(tput bold)                 #  bold
txtrst=$(tput sgr0)               #  reset


## Tools (It is inside the android folder) and inside is the Roms and Tree folder
### Tools/Roms (A copy of the rom is made when the build is finished and then maintained. So you can delete the source folder to have more space.)
### Tools/Tree (Copy the vendor and kernel folder into the "Common" folder) (copy your device folder into another with the name of the rom)
### Example
#          __________________________________________________________________
#         |                                                                  |
#         |  /home/Android/Tools/Tree/                                       |
#         |                       l___ Aicp/device/xiaomi/lavender           |
#         |                       l___ Common/vendor/xiaomi/lavender         |
#         |                       l___ Common/kernel/xiaomi/lavender         |
#         |__________________________________________________________________|
#
TOOL="${SCRIPT}/Tools"
TOOLTREE="${SCRIPT}/Tools/Tree"
TOOLROM="${SCRIPT}/Tools/Roms"
TOOLPATCH="/Tools/Patch"

## Out folder where the rom is compiled. Example to lavender: "out/target/product/lavender" 
OUTF="out/target/product/lavender/"

####################################################
VAL="derpfest droidx lineage rising"
## You can add your repo Android13

DERPFESTLINK="https://github.com/DerpFest-AOSP/manifest.git -b 13"
DROIDXLINK="https://github.com/DroidX-UI/manifest.git -b 13"
LINEAGELINK="https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs"
RISINGLINK="https://github.com/RisingTechOSS/android -b thirteen --git-lfs"

################### ZIP ROMS #################################
DERPFESTZIP="DerpFest*.zip"
DROIDXZIP="droidx*.zip"
LINEAGEZIP="lineage*.zip"
RISINGZIP="risingOS*.zip"
#####################################################

# Telegram Messages Bot

function telegrammsg() {
TOKEN="6481626578:AAGGF58KHiqkUnmHHnVlaBHc3Tcqyh3eQD8"
ID="-1001811098267"
curl -s -X POST https://api.telegram.org/bot$TOKEN/sendMessage -d chat_id=$ID -d text="$MESSAGE"
}

## Start script

function startfo() {
             if [ -d ${SCRIPT}/ ]; then
               echo ""
             else   
                mkdir ${SCRIPT}
             fi

			if [ -d ${SCRIPTFOLDER}/ ]; then	
                  echo ""
             else   
                mkdir ${SCRIPTFOLDER}
             fi

            if [ -d ${TOOL}/ ]; then	
                 echo ""
             else   
                mkdir ${TOOL}
             fi 

            if [ -d ${TOOLTREE}/ ]; then	
                 echo ""
             else   
                 mkdir ${TOOLTREE}
             fi 

            if [ -d ${TOOLROM}/ ]; then	
                 echo ""
             else   
                 mkdir ${TOOLROM}
             fi  
            
}

# Select ROM
function romselect() {
    # You can export the ROM by running export SCRIPTROM="<romnumber>". Example: export SCRIPTROM="1" (for LineageOS 16.0)
    if [[ -v SCRIPTROM ]]; then
    echo ""
    else
        	
        echo ""
		echo "         #####################################"
        echo ""	
		echo "         ${bold}   What rom do you want to ${cyan}build${txtrst}${bold} ?${txtrst}"
        echo ""
        echo "         #####################################"
		echo ""
        echo "                  [${cyan}${bold}derpfest${txtrst}]             Derpfest"
        echo "                  [${cyan}${bold}droidx${txtrst}]                  DroidX"
		echo "                  [${cyan}${bold}lineage${txtrst}]                Lineage"
        echo "                  [${cyan}${bold}rising${txtrst}]                Rising"
        echo ""
        echo ""
        read -p "        ${smul}${bold} Please, enter your choice ${txtrst}: ${cyan}${bold} " SCRIPTROM
        echo "${txtrst}"
    fi

    if [[ ${#SCRIPTROM} -lt 2 ]]; then 
    		
	    echo ""
		echo "        ${red}${bold}..................................O ${txtrst}"
        echo "        You didn't entered a valid option"
        echo ""
		ending
#Finish with error
        exit 1
     elif [[ $VAL == *$SCRIPTROM*   ]]; then

       ROS=$(echo -n ${SCRIPTROM:0:1} | tr '[:lower:]' '[:upper:]' ; echo ${SCRIPTROM:1} | tr '[:upper:]' '[:lower:]' )
       ROM="$ROS"
       ROMDIR="${SCRIPTFOLDER}/${ROM}"
       ZOPO=$(echo -n ${ROM}ZIP | tr '[:lower:]' '[:upper:]')
		echo ""
		echo "        ${green}${bold}................................./ ${txtrst}"
		echo "        You will build ${green}${bold}${ROM}${txtrst}"
        echo ""
     else 
        echo ""
		echo "        ${red}${bold}.................................0 ${txtrst}"
		echo "        You have not entered a correct option"
        echo ""
        ending
#Finish with error
        exit 1
     fi   
}

## Rom Folder
function romfolder() {
    if [ -d ${ROMDIR} ]; then
                   echo ""
				   echo "        ${orange}${bold}..................................!"
                   echo "        ${ROM}${txtrst} folder already exists"
                   echo ""
    else
                   echo ""
				   echo "        ${green}${bold}................................../ ${txtrst}"
                   echo "        Create folder to ${green}${bold}${ROM}${txtrst}"
                   echo ""
                   mkdir ${ROMDIR} 
    fi
	
	if [ -d ${ROMDIR}/.repo/ ]; then
                   echo ""
				   echo "        ${orange}${bold}..................................!"
                   echo "        ${ROM}${txtrst} repo already exists"
                   echo ""
    else
                   echo ""
				   echo "        ${green}${bold}................................../ ${txtrst}"
				   echo "        Add link to ${green}${bold}${ROM}${txtrst} repo" 
                   cd $ROMDIR
                   echo ""
                   echo "" 
		#Add repo link		   
        REP=$(echo -n ${ROM}LINK | tr '[:lower:]' '[:upper:]')
        repo init -u ${!REP}
    fi
}

# Repo sync
function syncrom() {
     
	if [[ -v SCRIPTSYNC ]]; then
    echo ""
    else
	    echo ""
		echo ""
		echo "         #######################################"
        echo ""
        echo "                   ${bold} Sync or skip: ${txtrst}"
        echo ""
        echo "           You could update ${cyan}${bold}${ROM}${txtrst} repository"
        echo ""
		echo "         #######################################"
		echo ""
        echo "                 [${cyan}${bold}yes${txtrst}] Sync Repository"
        echo "                 [${cyan}${bold}no${txtrst}]  Skip Sync"
		echo ""
		read -p "            ${smul}${bold} Please, write your choise ${txtrst}: ${cyan}${bold}"  SCRIPTSYNC
        echo "${txtrst}" 
    fi
    if [ $SCRIPTSYNC = "yes" ]; then
	    echo ""
		echo "        ${green}${bold}................................../ ${txtrst}"
        echo "        Synchronizing repository ${green}${bold}${ROM}${txtrst}"
        echo ""
		romfolder
###########################################################################################################################
DATE=$(date '+%d/%m/%Y')
HOURS=$(date '+%H:%M min')
MESSAGE="Start sync $ROM at $HOURS to $DATE $INFOCLI"
        telegrammsg
###########################################################################################################################
	    cd $ROMDIR	
	    if ping -c1 google.com &>/dev/null; then
        repo sync --no-clone-bundle --optimized-fetch --prune --force-sync -j$(nproc --all)
		     echo ""
			 echo "        ${orange}${bold}.............................| ${txtrst}"
             echo "        Sync done ${orange}${bold}${ROM}${txtrst}"
             echo ""
###########################################################################################################################
DATE=$(date '+%d/%m/%Y')
HOURS=$(date '+%H:%M min')
MESSAGE="Finish sync $ROM at $HOURS to $DATE $INFOCLI"
        telegrammsg
###########################################################################################################################
        else
		     echo ""
		     echo "        ${red}${bold}..................................- ${txtrst}"
             echo "        Sync failed ${red}${bold}${ROM}${txtrst} You need internet"
             echo ""
###########################################################################################################################
DATE=$(date '+%d/%m/%Y')
HOURS=$(date '+%H:%M min')
MESSAGE="Failed sync $ROM at $HOURS to $DATE $INFOCLI"
        telegrammsg
###########################################################################################################################
        ending
#Finish with error
        exit 1
        fi
    elif [ $SCRIPTSYNC = "no" ]; then
	    echo ""
		echo "        ${orange}${bold}..................................! ${txtrst}"
        echo "        Skip sync ${orange}${bold}${ROM}${txtrst}"
        echo ""
    else
		echo ""
		echo "        ${red}${bold}.....................................O ${txtrst}"
        echo "        You didn't entered a valid option"
        echo ""
		ending
#Finish with error
        exit 1

    fi
}

## Start build
function buildin() {
		    echo ""
	        echo "        ${green}${bold}................................../ ${txtrst}"
		    echo "        it will begin to build ${green}${bold}${ROM}${txtrst}"
            echo ""
            copytrees
##############################################Push telegram message####################################################
    DATE=$(date '+%d/%m/%Y')
    HOURS=$(date '+%H:%M min')
	MESSAGE="Start build  $ROM. Date: $DATE at $HOURS $INFOCLI"
	       telegrammsg
#######################################################################################################################	
}

#Clonado device tree
function copytrees() {

### Device T  
              if [ -d ${ROMDIR}/device/${DEVICES}/ ]; then
                   echo ""
				   echo "        ${orange}${bold}..................................! ${txtrst}"
                   echo "        ${orange}${bold}DT${txtrst} already exists"
                   echo ""
## Default
             elif [ -d ${TOOLTREE}/${ROM}/ ]; then	
                    echo ""
				    echo "        ${green}${bold}................................../ ${txtrst}"
                    echo "        Copying ${green}${bold}DT${txtrst}"
                    echo ""
                    cp -r ${TOOLTREE}/${ROM}/*         ${ROMDIR}

## Internet
			 elif ping -c1 google.com &>/dev/null; then
                    echo ""
                    echo ""
                    read -p "${smul}${bold} Please, write DT link ${txtrst}: ${cyan}${bold}" DT
                    echo "${txtrst}"
					echo "        Sync ${green}${bold}Repo DT${txtrst}"
                git clone $DT ${ROMDIR}/device/${DEVICES}

## Local
            else 
	 echo "      _________________________________________________________________________ "
     echo "     |                                                                         |"
     echo "     |                                                                         |"   
     echo "     |   - Prepare the dt, vt and kernel  a folder with the name you want.     |"                          
     echo "     |          Remember that the architecture is correct device and           |"   
     echo "     |             the files are extracted, not compressed in zip.             |"
     echo "     |                                                                         |" 
     echo "     |              For example to *Lavender*                                  |" 
     echo "     |                                                                         |"
     echo "     |                    My Folder/                                           |"
     echo "     |                       l___ device/xiaomi/lavender                       |"
     echo "     |                       l___ vendor/xiaomi/lavender                       |"
     echo "     |                       l___ kernel/xiaomi/lavender                       |"
     echo "     |                                                                         |"
     echo "     |                                                                         |"
     echo "     |        * Write the full path where your folder is located.              |"
     echo "     |                                                                         |" 
     echo "     |             For example: /home/YourUserPc/My Folder                     |" 
     echo "     |_________________________________________________________________________|"
		            echo ""
                    echo ""    
		            read -p "${smul}${bold} Please, write the *route* where you have saved your 3 tree ${txtrst}: ${cyan}${bold}" RUTA
                    echo "${txtrst}"
                    cp -r ${RUTA}/*         ${ROMDIR}
                    echo ""
				    echo "        ${green}${bold}................................../ ${txtrst}"
                    echo "        Copying your choise ${green}${bold} tree{txtrst}"	
                    echo ""			
                
			fi

### Vendor T         
           if [ -d ${ROMDIR}/vendor/${DEVICES}/ ]; then
                   echo ""
				   echo "        ${orange}${bold}..................................! ${txtrst}"
                   echo "        ${orange}${bold}VT${txtrst} already exists"
                   echo ""
## Default
           elif [ -d ${TOOLTREE}/${ROM}/ ]; then	
                   echo ""
				   echo "        ${green}${bold}................................../ ${txtrst}"
                   echo "        Copying ${green}${bold}VT{txtrst}"
                   echo ""
                   cp -r ${TOOLTREE}/Common/vendor         ${ROMDIR}
## Internet
			elif ping -c1 google.com &>/dev/null; then
                   echo ""
                   echo ""
                   read -p "${smul}${bold} Please, write VT link ${txtrst}: ${cyan}${bold}" VT
                   echo "${txtrst}"
				   echo "        Sync ${green}${bold}Repo VT${txtrst}"
                git clone $VT ${ROMDIR}/vendor/${DEVICES}
                
## Local
           else 
	 echo "      _________________________________________________________________________ "
     echo "     |                                                                         |"
     echo "     |                                                                         |"   
     echo "     |   - Prepare the dt, vt and kernel  a folder with the name you want.     |"                          
     echo "     |          Remember that the architecture is correct device and           |"   
     echo "     |             the files are extracted, not compressed in zip.             |"
     echo "     |                                                                         |" 
     echo "     |              For example to *Lavender*                                  |" 
     echo "     |                                                                         |"
     echo "     |                    My Folder/                                           |"
     echo "     |                       l___ device/xiaomi/lavender                       |"
     echo "     |                       l___ vendor/xiaomi/lavender                       |"
     echo "     |                       l___ kernel/xiaomi/lavender                       |"
     echo "     |                                                                         |"
     echo "     |                                                                         |"
     echo "     |        * Write the full path where your folder is located.              |"
     echo "     |                                                                         |" 
     echo "     |             For example: /home/YourUserPc/My Folder                     |" 
     echo "     |_________________________________________________________________________|"
		            echo ""
                    echo ""    
		            read -p "${smul}${bold} Please, write the *route* where you have saved your 3 tree ${txtrst}: ${cyan}${bold}" RUTA
                    echo "${txtrst}"
                    cp -r ${RUTA}/*         ${ROMDIR}
                    echo ""
				    echo "        ${green}${bold}................................../ ${txtrst}"
                    echo "        Copying your choise ${green}${bold}tree${txtrst} "	
                    echo ""			
                
		     fi

             if [ -d ${ROMDIR}/kernel/${DEVICES}/ ]; then
                   echo ""
				   echo "        ${orange}${bold}..................................! ${txtrst}"
                   echo "        ${orange}${bold}KT${txtrst}  already exists"
                   echo ""
## Default
            elif [ -d ${TOOLTREE}/${ROM}/ ]; then	
                    echo ""
				    echo "        ${green}${bold}................................../ ${txtrst}"
                    echo "        Copying ${green}${bold}KT${txtrst} "
                    echo ""
                    cp -r ${TOOLTREE}/Common/kernel/         ${ROMDIR}
## Internet
			elif ping -c1 google.com &>/dev/null; then
                
                    echo ""
                    echo ""
                    read -p "${smul}${bold} Please, write KT link ${txtrst}: ${cyan}${bold}" KT
                    echo "${txtrst}"
                    echo "        Sync ${green}${bold}Repo KT${txtrst}"
                git clone $KT ${ROMDIR}/kernel/${DEVICES}
## Local
            else 
	 echo "      _________________________________________________________________________ "
     echo "     |                                                                         |"
     echo "     |                                                                         |"   
     echo "     |   - Prepare the dt, vt and kernel  a folder with the name you want.     |"                          
     echo "     |          Remember that the architecture is correct device and           |"   
     echo "     |             the files are extracted, not compressed in zip.             |"
     echo "     |                                                                         |" 
     echo "     |              For example to *Lavender*                                  |" 
     echo "     |                                                                         |"
     echo "     |                    My Folder/                                           |"
     echo "     |                       l___ device/xiaomi/lavender                       |"
     echo "     |                       l___ vendor/xiaomi/lavender                       |"
     echo "     |                       l___ kernel/xiaomi/lavender                       |"
     echo "     |                                                                         |"
     echo "     |                                                                         |"
     echo "     |        * Write the full path where your folder is located.              |"
     echo "     |                                                                         |" 
     echo "     |             For example: /home/YourUserPc/My Folder                     |" 
     echo "     |_________________________________________________________________________|"
		            echo ""
                    echo ""    
		            read -p "${smul}${bold} Please, write the *route* where you have saved your 3 tree ${txtrst}: ${cyan}${bold}" RUTA
                    echo "${txtrst}"
                    cp -r ${RUTA}/*         ${ROMDIR}
                    echo ""
				    echo "        ${green}${bold}................................../ ${txtrst}"
                    echo "        Copying your choise ${green}${bold}tree${txtrst}"
                    echo ""				
                
				fi

}


## End build
function buildfin() {
if [ $? -eq 0 ]; then
                     echo ""
	                 echo "        ${orange}${bold}..................................| ${txtrst}"
                     echo "        Finished build ${orange}${bold}${ROM}${txtrst}" 
                     echo "" 
		             cp ${OUTF}${!ZOPO}   ${TOOLROM}
##############################################Push telegram message####################################################
    DATE=$(date '+%d/%m/%Y')
    HOURS=$(date '+%H:%M min')
	MESSAGE="Finished build ${ROM}. Date: $DATE at $HOURS $INFOCLI"
	         telegrammsg
#######################################################################################################################		
                else
                      echo ""
	                  echo "        ${red}${bold}..................................- ${txtrst}"
                      echo "        Error compiling ${red}${bold}${ROM}${txtrst}"
                      echo ""
##############################################Push telegram message####################################################
    DATE=$(date '+%d/%m/%Y')
    HOURS=$(date '+%H:%M min')
	MESSAGE="Error compiling $ROM. Date: $DATE at $HOURS $INFOCLI"
	         telegrammsg
#######################################################################################################################	
	               ending
#Finish with error
        exit 1
                fi

}

# Build Rom
function buildrom() {

    if [[ -v BUILDROM ]]; then
    echo ""
    else
        echo ""
		echo "         #####################################"
		echo ""
        echo "               ${bold}  Build or Skip :    ${txtrst}"
        echo ""
        echo "               You could build ${cyan}${bold}${ROM}${txtrst}"
        echo ""
		echo "         #####################################"
		echo ""
        echo "               [${cyan}${bold}yes${txtrst}] Build"
        echo "               [${cyan}${bold}no${txtrst}]  No"
        echo ""
        read -p "           ${smul}${bold} Please, write your choise ${txtrst}: ${cyan}${bold}" BUILDROM
        echo "${txtrst}"
    fi

    if [ $BUILDROM = "yes" ]; then
	    echo ""
		echo "        ${green}${bold}................................../ ${txtrst}"
        echo "        Cloning necessary files"
        echo ""
        cd $ROMDIR
################		   
        if [ $SCRIPTROM = "derpfest" ]; then
            buildin
		    source build/envsetup.sh
            lunch derp_lavender-userdebug
            mka derp
            buildfin
		
        elif [ $SCRIPTROM = "lineage" ]; then		
            buildin
		    source build/envsetup.sh
            breakfast lavender
            brunch lavender
            buildfin
          
	   elif [ $SCRIPTROM = "rising" ]; then		
            buildin
		    source build/envsetup.sh
            lunch lineage_lavender-userdebug
            mka bacon 
            buildfin		  

        elif [ $SCRIPTROM = "droidx" ]; then
            buildin
		    source build/envsetup.sh
            lunch droidx_lavender-userdebug
            m bacon
            buildgin
    fi			
    elif [ $BUILDROM = "no" ]; then
            echo ""
		    echo "        ${orange}${bold}..................................O ${txtrst}"
			echo "        Skip Build ${orange}${bold}${ROM}${txtrst}" 
            echo ""      		
	
	else
	    echo ""
	    echo "        ${red}${bold} ................................../ ${txtrst}"
        echo "        You didn't entered a valid option"
        echo ""
		ending
#Finish with error
        exit 1
   
    fi
}      

# Upload ROM
function uploadrom() {

        if [[ -v UPLOADROM ]]; then
    echo ""
    else
		echo ""
		echo "         #####################################"
        echo ""
        echo "   ${bold}          Do you want upload the rom?  ${txtrst}"
		echo ""
        echo "               You could upload ${cyan}${bold}${ROM}${txtrst}" 
        echo "                to sourceforge"
        echo ""
		echo "         #####################################"
		echo ""
        echo "                 [${cyan}${bold}yes${txtrst}] Upload"
        echo "                 [${cyan}${bold}no${txtrst}]  Skip"
		echo ""
		read -p "          ${smul}${bold} Please, write your choise ${txtrst}: ${cyan}${bold}" UPLOADROM
        echo "${txtrst}"
    fi

    if [ $UPLOADROM = "yes" ]; then
        
              echo ""
			  echo "        ${green}${bold}................................../ ${txtrst}"
              echo "        Uploading ${green}${bold}${ROM}${txtrst}"
              echo ""			                  

##############################################Push telegram message############################################################
	DATE=$(date '+%d/%m/%Y')
    HOURS=$(date '+%H:%M min')
	MESSAGE="Uploading $ROM. Date: $DATE at $HOURS $INFOCLI"
	         telegrammsg
###############################################################################################################################	            
              scp ${TOOLROM}/${!ZOPO}   ${LINKUPL}${ROM}/			  
              echo ""
			  echo "        ${orange}${bold}..................................| ${txtrst}"
              echo "        Uploaded ${orange}${bold}${ROM}${txtrst}"
              echo ""
##############################################Push telegram message############################################################
    FILENAME=$(find ${TOOLROM}/${!ZOPO} | cut -d "/" -f 7)
	UPDATE_URL1="${LINKSOU}/${ROM}/$FILENAME/download"
	DATE=$(date '+%d/%m/%Y')
    HOURS=$(date '+%H:%M min')
	MESSAGE="Updated $ROM. Link:$UPDATE_URL1 Date: $DATE at $HOURS $INFOCLI"
	         telegrammsg
###############################################################################################################################	
            push_ota_json
      elif [ $UPLOADROM = "no" ]; then
	          echo ""
			  echo "        ${orange}${bold}..................................! ${txtrst}"
              echo "        Skip Upload ${orange}${bold}${ROM}${txtrst}"
              echo ""       		
      else
		      echo ""
			  echo "        ${red}${bold}.................................- ${txtrst}"
              echo "        You didn't entered a valid option"
              echo ""
	  ending
#Finish with error
        exit 1			

fi	
}

# Make clean
function romclean() {
    # You can export the ROM by running export SCRIPTROM="<text>". Example: export SCRIPTROM="lineage" (for LineageOS 16.0)
    if [[ -v ROMCLEAN ]]; then
    echo ""
    else
        echo ""
		echo ""
		echo "    ####################################################"
        echo ""
        echo "                   ${bold}   Final option  ${txtrst}"
        echo ""
        echo "     You could clean your old build or all folder build"
        echo "                       ${green}${bold}${ROM}${txtrst}"
        echo ""
		echo "    ####################################################"
		echo ""
        echo "               [${cyan}${bold}make${txtrst}]    Make Clean"
        echo "              [${cyan}${bold}delete${txtrst}]   Delete"
        echo "                [${cyan}${bold}no${txtrst}]     Nothing"
		echo ""
		echo ""
        read -p "        ${smul}${bold} Please, enter your choise ${txtrst}: ${cyan}${bold}"  ROMCLEAN
        echo "${txtrst}"
    fi
	
    if [ $ROMCLEAN = "make" ]; then
        echo ""
		echo "        ${green}${bold}................................../ ${txtrst}"
		echo "        Make clean ${green}${bold}${ROM}${txtrst} "
        echo ""
        cd $ROMDIR
        make clean
##############################################Push telegram message############################################################
	DATE=$(date '+%d/%m/%Y')
    HOURS=$(date '+%H:%M min')
	MESSAGE="Make Clean $ROM. Date: $DATE at $HOURS $INFOCLI"
	         telegrammsg
###############################################################################################################################	
				
    elif [ $ROMCLEAN = "delete" ]; then
	    echo ""
		echo "        ${green}${bold}................................../ ${txtrst}"
        echo "        Deleting all folder to ${cyan}${bold}${ROM}${txtrst}"
        echo ""
        rm -rf $ROMDIR
##############################################Push telegram message############################################################

	DATE=$(date '+%d/%m/%Y')
    HOURS=$(date '+%H:%M min')
	MESSAGE="Delete folder $ROM.  Date: $DATE at $HOURS $INFOCLI"
	         telegrammsg
		ending
###############################################################################################################################	
    elif [ $ROMCLEAN = "no" ]; then
	    echo ""
		echo "        ${orange}${bold}..................................O ${txtrst}"
        echo "        Nothing"
        echo ""
		ending
    else
	    echo ""
		echo "        ${red}${bold}.....................................- ${txtrst}"
        echo "        You didn't entered a valid option"
        echo ""
		ending
#Finish with error
        exit 1		

    fi
}

function ending() {
    sleep 3s
    echo ""
    echo "      ${bold} **********************************"
    echo ""
    echo "          ${smul}Thanks to use Script Build${txtrst}"  
    echo "" 
    echo ""  
	echo "        It was created for true ${cyan}${bold}BuildBot${txtrst}"	
    echo "" 	
    echo "      ${bold} **********************************"
    echo "                     * *" 	
    echo "                      *"	
    echo ""	
    echo "                 Contact:${txtrst}"
    echo ""		
    echo "      ${bold} My Telegram:${cyan}http://t.me/Febr1Cahyaa       ${txtrst}"		
    echo ""		
    echo "      ${bold} My Github:${cyan} https://github.com/FebriCahyaa${txtrst}"
    echo ""
    echo "      ${bold} Source code:${cyan} https://github.com/FebriCahyaa/buildbot_script${txtrst}"
    echo ""	

}

# Main program
function main() {
echo ""
echo ""    
echo "          ${bold} *********************************${txtrst}"		
echo "                                          "		
echo "          ${bold}          𝕾𝖈𝖗𝖎𝖕𝖙 𝕭𝖚𝖎𝖑𝖉                "		
echo "                                 "		
echo "                         by         ${txtrst}            "
echo "                                 "		
echo "           ${cyan}${bold}           FebriCahyaa       ${txtrst} "		
echo "                                "		
echo "          ${bold} *********************************${txtrst}"
echo ""	

    startfo
    romselect
    syncrom
    patchrom
	buildrom
    uploadrom
    romclean
}

#Execute the program
main
