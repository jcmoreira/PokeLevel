#!/usr/bin/env bash
#
#=========*=========*=========*=========*=========*
#	PokeLevel beta 3
#	Author : UltrafunkAmsterdam
#	https://www.github.com/UltrafunkAmsterdam
#=========*=========*=========*=========*=========*
#
#	FUNCTIONS.SH

function Time()
{
	date "+%H:%M:%S"
}
 Date()
{
	date "+%d-%m-%y" 
}
TimeStamp()
{
	echo -e -n "$(Date) $(Time)"
} 

	Reset='\e[0m'
	Bla='\e[0;30m';     BBla='\e[1;30m';    UBla='\e[4;30m';    IBla='\e[0;90m';    BIBla='\e[1;90m';   On_Bla='\e[40m';    On_IBla='\e[0;100m';
	Red='\e[0;31m';     BRed='\e[1;31m';    URed='\e[4;31m';    IRed='\e[0;91m';    BIRed='\e[1;91m';   On_Red='\e[41m';    On_IRed='\e[0;101m';
	Gre='\e[0;32m';     BGre='\e[1;32m';    UGre='\e[4;32m';    IGre='\e[0;92m';    BIGre='\e[1;92m';   On_Gre='\e[42m';    On_IGre='\e[0;102m';
	Yel='\e[0;33m';     BYel='\e[1;33m';    UYel='\e[4;33m';    IYel='\e[0;93m';    BIYel='\e[1;93m';   On_Yel='\e[43m';    On_IYel='\e[0;103m';
	Blu='\e[0;34m';     BBlu='\e[1;34m';    UBlu='\e[4;34m';    IBlu='\e[0;94m';    BIBlu='\e[1;94m';   On_Blu='\e[44m';    On_IBlu='\e[0;104m';
	Pur='\e[0;35m';     BPur='\e[1;35m';    UPur='\e[4;35m';    IPur='\e[0;95m';    BIPur='\e[1;95m';   On_Pur='\e[45m';    On_IPur='\e[0;105m';
	Cya='\e[0;36m';     BCya='\e[1;36m';    UCya='\e[4;36m';    ICya='\e[0;96m';    BICya='\e[1;96m';   On_Cya='\e[46m';    On_ICya='\e[0;106m';
	Whi='\e[0;37m';     BWhi='\e[1;37m';    UWhi='\e[4;37m';    IWhi='\e[0;97m';    BIWhi='\e[1;97m';   On_Whi='\e[47m';    On_IWhi='\e[0;107m';
	
Logger()
{	
	PRETTYNAME="PokeLevel"
	LOGTYPE="$1"
	MESSAGE="$2"
	#Logger Templates
	DISP_START="\n${BIWhi}${On_Pur} $PRETTYNAME ${Reset}${BIWhi} $MESSAGE ${Reset}\n"
	DISP_INFO_STYLE="${BIWhi}[ $PRETTYNAME | ${Reset}${BIWhi}Info${Reset}${BIWhi} ] $MESSAGE ${Reset}"
	DISP_ERROR_STYLE="${BIWhi}[ $PRETTYNAME | ${Reset}${BIWhi}${On_Red}Error${Reset}${BIWhi} ] $MESSAGE ${Reset}"
	DISP_SUCCESS_STYLE="${BIWhi}[ $PRETTYNAME | ${Reset}${BIWhi}${On_Gre}Success${Reset}${BIWhi} ] $MESSAGE ${Reset}"
	LOGFILE_STYLE="[ $PRETTYNAME | $(TimeStamp) | $(echo $LOGTYPE | tr '[a-z]' '[A-Z]') ] $MESSAGE ${Reset}"
	#Logger Logic
	[[ ! -z ${LOGTYPE} ]] && [[ -z ${MESSAGE} ]] && echo -e "${BIWhi} $LOGTYPE ${Reset}" && return 0
	[[ -z $LOGTYPE ]] && echo -e "${BIWhi}${On_Red} Logger () : First argument missing ( Log type ) ${Reset}"
	[[ -z $MESSAGE ]] && echo -e "${BIWhi}${On_Red} Logger () : Second argument missing ( Message ) ${Reset}"
        [[ "$(echo $LOGTYPE | tr '[a-z]' '[A-Z]')" == "START" ]] && echo -e "$DISP_START"  
	[[ "$(echo $LOGTYPE | tr '[a-z]' '[A-Z]')" == "ERROR" ]] && echo -e "$DISP_ERROR_STYLE" 
	[[ "$(echo $LOGTYPE | tr '[a-z]' '[A-Z]')" == "SUCCESS" ]] && echo -e "$DISP_SUCCESS_STYLE"
	[[ "$(echo $LOGTYPE | tr '[a-z]' '[A-Z]')" == "INFO" ]] && echo -e "$DISP_INFO_STYLE"
	return 0
}

Usage()
{
	Logger start " Usage & Debug "
	echo "Arguments : $ARGS_ARRAY"
	echo "Path to this script from caller : ${0}"
	echo "Path to this script (full) : $BASE_DIR/$0"
	echo "Parent folder : ${0%/*}"
	echo "My name : ${0##*/}"
	echo -e "\n\n${BIWhi}${On_Pur}$PRETTYNAME${Reset} ${BIWhi}USAGE\n\nFrom current path : $0 arg1 arg2\n ${Reset}\n"
}

StopSelf()
{
	Logger info "Shutting down .. "
	for account in "${ACCOUNTS[@]}";do IFS=, read a b c d <<< "$account"; ReturnAccount $a $b $c $d ; done
	echo -e "\n"
	Logger info "Thank you for using PokeLevel"
	ps -ef | grep -E "[r]un.sh" | awk '{print $2}' | xargs kill -9
	kill -9 $PID
	exit 1
}

CheckOS() 
{
	distro=$(lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om)
	which yum &>/dev/null && install="yum -y install "
	which zyppe &>/dev/null && install="zypper -n install "
	which apt-get &>/dev/null && install="sudo apt-get -y install "
	ec=$?
	[ $ec -eq 0 ] && return 0 || return 1
}

IsInstalled()
{
	for x in "$@" ; do 
	which "$x" &>/dev/null 
	ec=$? 
	[ $ec -eq 0 ] && Logger success "$x is found on your machine .. " 
	[ $ec -gt 0 ] && Logger error "$x is needed for this script to run .."  && sleep 2 && Logger info "Trying to install " && sleep 1 && sudo ${install} "$x" 
	done
}

ReceivedExit(){
	clear
	Logger start " [ https://github.com/ultrafunkamsterdam ]" 
	Logger success "Received ctrl+c or other interruption signal .. " ;
	Logger info "Quitting running session of account $username .." ; sleep 1
	ps -ef | grep -E "[p]okecli.py|[${username::1}]${username:1}" | awk '{print $2}' | xargs kill -9
	StopSelf && exit
}

Init(){
	touch ${THISPATH}/foo 2>/dev/null && rm -f ${THISPATH}/foo || Logger "error" "Folder has incorrect permissions! Please make it writeable by the current user"
	CheckOS
}

GenerateNick(){
	nick=
	nick+=$(gpw | head -n 1)
	nick+=$(shuf -i 0001-9999 -n 1)
	echo $nick
	[[ $? -eq 0 ]] && return 0 || return 1
}

CreateConfig(){

	[[ ! -f $POGOBOT_PATH/pokemongo_bot/cell_workers/buddy_pokemon.py.bak ]] && mv -f $POGOBOT_PATH/pokemongo_bot/cell_workers/buddy_pokemon.py $POGOBOT_PATH/pokemongo_bot/cell_workers/buddy_pokemon.py.bak && cp -f $POGOBOT_CONFIGFOLDER/base/buddy_pokemon.py $POGOBOT_PATH/pokemongo_bot/cell_workers/buddy_pokemon.py
		
	[[ -f $POGOBOT_CONFIGFOLDER/$username/$username.json ]] && POGOBOT_CONFIGFILE=$POGOBOT_CONFIGFOLDER/$username/$username.json && return 0 
	
	Logger "info" "CreateConfig() : Creating configuration file for $username (team: $TEAM) in $POGOBOT_CONFIGFOLDER/$username/$username.json"
	
        [[ "$(echo $TEAM | tr '[a-z]' '[A-Z]')" == "YELLOW" ]] && TEAM="3"
	[[ "$(echo $TEAM | tr '[a-z]' '[A-Z]')" == "RED"  ]] && TEAM="2"
	[[ "$(echo $TEAM | tr '[a-z]' '[A-Z]')" == "BLUE" ]] && TEAM="1"


	
	[[ ! -d $POGOBOT_CONFIGFOLDER/$username ]] && mkdir $POGOBOT_CONFIGFOLDER/$username
	cat $POGOBOT_BASE_CONFIGFILE | jq .tasks[3].config.nickname="\"$(GenerateNick)\"" |  jq .tasks[3].config.team="$TEAM" > $POGOBOT_CONFIGFOLDER/tmpcnf.json && mv $POGOBOT_CONFIGFOLDER/tmpcnf.json $POGOBOT_CONFIGFOLDER/$username/$username.json
	[[ $? -eq 0 ]] && return 0 || return 1
}

CreateAuthConfig(){

	[[ -f $POGOBOT_CONFIGFOLDER/$username/$username.auth.json ]] && POGOBOT_AUTHCONFIGFILE=$POGOBOT_CONFIGFOLDER/$username/$username.json && return 0 
	Logger "Info" "CreateAuthConfig() : Creating Auth configuration file for $username in $POGOBOT_CONFIGFOLDER/$username/$username.auth.json"
	
	HASH_KEY=$HASH_KEY1
	
	if [ ! -z ${HASH_KEY1} ] && [ ! -z ${HASH_KEY2} ];then 
		HASHKEY1_USEAMOUNT=$(grep -Rio "$HASH_KEY1" ${THISPATH}/config/* | wc -l )
		HASHKEY2_USEAMOUNT=$(grep -Rio ${HASH_KEY2} ${THISPATH}/config/* | wc -l )
		if [ "${HASHKEY1_USEAMOUNT}" -gt "${HASHKEY2_USEAMOUNT}" ]
		then 
		  HASH_KEY="${HASH_KEY2}"
		  else 
		  HASH_KEY="${HASH_KEY1}"
		fi 
	fi
	cat ${POGOBOT_BASE_AUTHCONFIGFILE} | jq .auth_service="\"$auth\"" |  jq .username="\"$username\"" | jq .password="\"$password\"" | jq .location="\"$LOCATION\"" | jq .gmapkey="\"$GMAPS_KEY\"" | jq .hashkey="\"$HASH_KEY\"" > $POGOBOT_CONFIGFOLDER/tmpauthcnf.json && mv $POGOBOT_CONFIGFOLDER/tmpauthcnf.json $POGOBOT_CONFIGFOLDER/$username/$username.auth.json && POGOBOT_AUTHCONFIGFILE="$POGOBOT_CONFIGFOLDER/$username/$username.json"
	[[ $? -eq 0 ]] && return 0 || return 1
}


GetAccount(){
	sed -i '/'"$b"',''/c'"$a"','"$b"','"$c"',N' ${ACCOUNTS_FILE}
	Logger "Success" "Account $b is going for a spin, so this account is marked N(ot) available in your accountlist ${ACCOUNTS_FILE} "
	[[ $? -eq 0 ]] && return 0 || return 1
}

ReturnAccount(){
	sed -i '/'"$b"',''/c'"$a"','"$b"','"$c"',Y' ${ACCOUNTS_FILE}
	exitcode=$?
	Logger "Success" "Account $b is being returned as available in ${ACCOUNTS_FILE} "
	return 0
}

URLS=()

KillSingle()
{
    ps -ef | grep -E "[p]okecli.py|[${username::1}]${username:1}" | awk '{print $2}' | xargs kill -9  && ps -ef | grep -iE "sleep $TIME_RUN" | awk '{print $2}' | xargs kill -9 &>/dev/null && return 0
}

Reader(){
   while read -r RAW; do
   Logger info "$RAW"
   echo $RAW >> "$LOGFOLDER/$(Date)-$username.log"
   echo $RAW | grep -i -e "captcha encountered" -e "Server busy or offline, reconnecting" -e "Login process failed" -e "decode byte 0x9c in position"
   if [ "$?" -eq "0" ]; then KillSingle; fi
   done
  
}


StartBot(){
	cd "${POGOBOT_PATH}"
	. bin/activate
	touch "${LOGFOLDER}/$(Date)-${username}.log"
	python ./pokecli.py -af "${POGOBOT_CONFIGFOLDER}/${username}/${username}.auth.json" -cf "${POGOBOT_CONFIGFOLDER}/$username/$username.json" 2>&1 | Reader &
	sleep ${TIME_RUN} && ps -ef | grep -E "[p]okecli.py|[${username::1}]${username:1}" | awk '{print $2}' | xargs kill -2 && sleep 8 && Logger "success" "Account ${username} went through the botting session." && sleep 2
	deactivate
	cd "${THISPATH}"
	return 0
}

NumberTotal()
{
	cat "${ACCOUNTS_FILE}" | grep -v ^$ | wc -l
}
NumberAvailable()
{
	cat "${ACCOUNTS_FILE}" | grep -iE ',Y$' | wc -l
}
NumberNotAvailable()
{
	cat "${ACCOUNTS_FILE}" | grep -iE ',N$' | wc -l
}


Main(){
clear
echo -e "\n\n"
Logger start " [ https://github.com/ultrafunkamsterdam ]        "    
Logger " Accounts total       : $(NumberTotal)	        	      "
Logger " Available for run    : $(NumberAvailable)              "  
echo -e "\n" 
Logger " Account starting now : ${username}              		      "
Logger " Location             : ${LOCATION}			                "
Logger " Team(if not chosen)  : ${TEAM} (1=blue,2=red,3=yellow) "
Logger " Timer                : ${TIME_RUN} seconds 	            "          
echo -e "\n"									
sleep 3
Logger Success "Starting Bot ... "
for i in {00..30}; do echo -n -e ". " && sleep 0.1;done
return 0
}


ACCOUNTS=()
CAPTCHAURLS=()

LoopCSV(){

while [ "$(NumberAvailable)" -ge "1" ];do
	
	IFS=, read a b c d <<< "$(cat ${ACCOUNTS_FILE} | grep -iE ",Y$" | head -n 1)"
	auth=$a && username=$b && password=$c && available=$d
	ACCOUNTS=("${ACCOUNTS[@]}" "$a,$b,$c,$d")
	Main
	GetAccount 
	CreateConfig 
        CreateAuthConfig
	StartBot
	sleep 1
	echo -e "Removing ${THISPATH}/config/$b/$b.auth.json to prevent old hash keys from staying in conf"
	rm -f config/$b/$b.auth.json 
done
}
