#!/bin/bash

cr=$'\r'
echo " - Generating Random D&D 5e Playable Character - "


# TEST
#curl -X GET "https://www.dnd5eapi.co/api/ability-scores/cha" -H "Accept: application/json"

###### Generate race #####
function generateRace (){
    raceArray=("dragonborn" "dwarf" "elf" "gnome" "half-elf" "half-orc" "halfling" "human" "tiefling")
    raceArrayLen=${#raceArray[@]}
    randomRace=${raceArray[$((RANDOM % $raceArrayLen))]}
    randomRace="${randomRace%$cr}"

    # echo "$randomRace" | tr -dc '[:print:]' | od -c

    url='https://www.dnd5eapi.co/api/races/'
    url+=$randomRace

    # echo $url
    race="$(curl -L "$url" -H 'Accept: application/json' --silent)"
    # echo $race
    echo $race
}
##### #####

##### Generate class #####
function generateClass() {

    classArray=("barbarian" "bard" "cleric" "druid" "fighter" "monk" "paladin" "ranger" "rogue" "sorcerer" "warlock" "wizard")
    classArrayLen=${#classArray[@]}
    randomClass=${classArray[$((RANDOM % $classArrayLen))]}
    randomClass="${randomClass%$cr}"

    # echo "$randomClass" | tr -dc '[:print:]' | od -c

    url='https://www.dnd5eapi.co/api/classes/'
    url+=$randomClass

    # echo $url
    class="$(curl -L "$url" -H 'Accept: application/json' --silent)"
    echo $class

}
##### #####


##### Generate Subrace #####
function generateSubrace(){
    echo Generate Subrace
}
##### #####




##### Generate gender identity #####
function generateGender(){
    genderArray=("male" "female" "non-binary")
    genderArrayLen=${#genderArray[@]}
    randomGender=${genderArray[$((RANDOM % $genderArrayLen))]}
    randomGender="${randomGender%$cr}"
    echo $randomGender
}

##### Generate name - AI? or API? #####
function generateName(){ #RACE SHOULD BE LOWERCASE
    race=$1
    gender=$2
    
    # binaryArray=("male" "female")
    # randomBinary=${binaryArray[$((RANDOM % 2))]}
    # [[ $2 = non-binary ]] && gender=$randomBinary || gender=$2
    if [ "$gender" = "non-binary" ]; then
        nameUrl="https://muna.ironarachne.com/$race/?count=1"
    else
        nameUrl="https://muna.ironarachne.com/$race/?count=1&nameType=$gender"
    fi
    # nameUrl="https://muna.ironarachne.com/$race/?count=1&nameType=$gender"
    

    name="$(curl -L "$nameUrl" -H 'Accept: application/json' --silent  | jq '.names'[0])"   
    name="$(echo $name | tr -d '"')"

    echo $name
    # echo $nameUrl
}
##### #####


##### Generate Ability scores ####


##### #####

# Generate Starting Equipment

# Generate goals, fears, etc - Table or AI

# Generate art - AI




function main(){
    declare -A charMap
    charMap["race"]=$(generateRace)
    # echo ${charMap["race"]}
    charMap["race_name"]="$(echo ${charMap["race"]} | jq '.index' | tr -d '"' | tr -d $cr)"
    # echo ${charMap["race_name"]}
    # echo $race_name
    charMap["class"]=$(generateClass)
    # echo ${charMap["class"]}
    charMap["class_name"]="$(echo ${charMap["class"]} | jq '.index' | tr -d '"' | tr -d $cr)"
    # echo ${charMap["class_name"]}
    charMap["gender"]=$(generateGender)
    # echo ${charMap["gender"]}
    # echo $char_gender
    charMap["name"]=$(generateName "${charMap["race_name"]}" "${char_gender}") 
    # echo ${charMap["name"]}


    echo Your randomly generated character is a ${charMap[gender]} ${charMap[race_name]} ${charMap[class_name]} named ${charMap[name]}

    ###### JSON --> Array #######
    # jq -r 'to_entries|map("race[\(.key)]=\(.value|tostring)")|.[]' $(generateRace)
    # echo $race[index]

    # declare -A myarray
    # while IFS="=" read -r key value
    # do
    #     myarray[$key]="$value"
    # done < <(jq -r 'to_entries|map("\(.key)=\(.value)")|.[]' $charRace)
    # echo ${myarray[race]}

    # echo SPLITTING METHODS

    # char_race=$(generateRace)
    # echo $char_race
    # echo $char_race | cat -v

    # char_race_name="$(echo ${char_race} | jq '.index' | tr -d '"' | tr -d $cr)"
    # echo $char_race_name
    # echo $char_race_name | cat -v
    # echo "$char_race_name" | tr -dc '[:print:]' | od -c

    # char_gender=$(generateGender)
    # echo $char_gender
    # echo $char_gender | cat -v
    # echo "$char_gender" | tr -dc '[:print:]' | od -c

    # char_name=$(generateName "$char_race_name" "$char_gender") 
    # echo $char_name
    

    ## create fdf file with all info of character
    ## use pdftk to fill pdf fillable form of character sheet
    #### pdftk charSheetFormFillable.pdf fill_form charData.fdf output charSheet.pdf
    #### https://www.youtube.com/watch?v=eCPcSdkapXg

}
main