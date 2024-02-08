#!/bin/bash


###############################welcome message###################################################


function introscreen {
    while true; do
        CHOICE=$(whiptail --clear --title "Welcome" --menu "Choose an option:" 15 60 2 \
            "1)" "Enter to Our Database" \
            "2)" "Exit" \
            3>&1 1>&2 2>&3)

        case $CHOICE in
            "1)" )
                if [ ! -e "$(pwd)/DataBase" ]; then
                    mkdir -p ./DataBase
                fi
                cd ./DataBase/
                separator
                whiptail --title "Loading" --msgbox "Database is loading....!" 8 45
                read -p "press any key to continue...."
                main_menu
                ;;
            "2)" )
                whiptail --title "Exit" --msgbox "Database exit....! Good Bye!..." 8 45
                exit
                ;;
            * )
                whiptail --title "Error" --msgbox "Invalid input, choose a correct option." 8 45
                read -p "press any key to continue...."
                ;;
        esac
    done
}

#######################################main menu#####################################################################################
function main_menu {
    while true; do
        CHOICE=$(whiptail --title "Main Menu" --menu "Database Menu" 15 60 6 \
            "1)" "Create Database" \
            "2)" "Rename Database" \
            "3)" "List Databases" \
            "4)" "Connect to Database" \
            "5)" "Drop Database" \
            "6)" "Exit" \
            3>&1 1>&2 2>&3)

        case $CHOICE in
            "1)" )
                separator
                createDB
                ;;
            "2)" )
                separator
                renameDB
                ;;
            "3)" )
                separator
                listDatabase
                ;;
            "4)" )
                separator
                connectDB
                ;;
            "5)" )
                separator
                dropDB
                ;;
            "6)" )
                echo -e "\e[41mDatabase exit....!\e[0m"
                echo "Good Bye!..."
                exit
                ;;
            * )
                echo -e "\e[41mInvalid input\e[0m"
                read -p "press any key to continue...."
                ;;
        esac
    done
}

#############################TABLE MENU#############################################################

function table_menu {
    while true; do
        CHOICE=$(whiptail --title "Table Menu" --menu "Table Menu" 15 60 9 \
            "1)" "Create Table" \
            "2)" "List Tables" \
            "3)" "Insert Data" \
            "4)" "Display Table" \
            "5)" "Display Record" \
            "6)" "Update Table" \
            "7)" "Delete Table" \
            "8)" "Delete Record" \
            "9)" "Exit" \
            3>&1 1>&2 2>&3)

        case $CHOICE in
            "1)" )
                separator
                createTable
                ;;
            "2)" )
                separator
                listTables
                ;;
            "3)" )
                separator
                insertData
                ;;
            "4)" )
                separator
                displayTable
                ;;
            "5)" )
                separator
                displayRow
                ;;
            "6)" )
                separator
                updateTable
                ;;
            "7)" )
                separator
                delete_table
                ;;
            "8)" )
                separator
                deleteRecord
                ;;
            "9)" )
                echo -e "\e[41mDatabase exit....!\e[0m"
                echo "Good Bye!..."
                exit
                ;;
            * )
                echo -e "\e[41mInvalid input\e[0m"
                read -p "press any key to continue...."
                ;;
        esac
    done
}

#############################create database ###############################################
function createDB {
        read -p "please, Enter The Name of Database : " dbname
        #check if the database exists
        if [[ -e $dbname ]]; then
                echo -e "\e[41mDatabase name is already used.\e[0m"
                read -p "press any key to continue...."
        #check for null input
        elif [[ $dbname = "" ]]; then
                echo -e "\e[41mInvaild name, Please enter a correct one\e[0m"
                read -p "press any key to continue...."
        #check for special characters
        elif [[ $dbname =~ [/.:\|-] ]]; then
                echo -e "\e[41mYou can't enter these characters, please enter vaild name\e[0m"
                read -p "press any key to continue...."

                # Check if the database name starts with a letter, has more than two letters
        elif [[ ! $dbname =~ ^[a-zA-Z][a-zA-Z0-9_]{2,}$ || $dbname =~ ^\s ]]; then
        echo -e "\e[41mInvalid name. The database name must have more than two letters.\e[0m"
        read -p "Press any key to continue...."

        #new database
        # check if the database name start with a letter
        elif [[ $dbname =~ ^[a-zA-Z]+ ]]; then
                mkdir -p "$dbname"
                cd "./$dbname" > /dev/null 2>&1
                newloc=`pwd`
                if [[ "$newloc" = `pwd` ]]; then
                        echo -e "\e[42mDatabase created sucessfully in $(pwd)\e[0m"
                        read -p "press any key to continue...."
                        table_menu
                else
                        cd - > /dev/null 2>&1
                        echo -e "\e[41mCan't access this Database\e[0m"
                        read -p "press any key to continue...."
                fi
        # check for numbers or any special character
        else
                echo -e "\e[41mDatabase name can't start with nimber or specialcharacter\e[0m"
                read -p "press any key to continue...."
        fi
        separator;
}

###############################RENAME DATABASE##############################################################
#rename database
function renameDB {
  # Display existing databases
  echo Databases:$'\n'$(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d')
  separator;
  read -p "Enter the name of the database you want to rename: " oldName

  # Check if null input
  if [[ "$oldName" = '' ]]; then
    echo -e "\e[41mInvalid input, please enter a correct one\e[0m"
    read -p "press any key to continue...."
    separator;
    return
  fi

  # Check if the database exists
  if ! [[ -d "$oldName" ]]; then
    echo -e "\e[41mThis database doesn't exist\e[0m"
    read -p "press any key to continue...."
    separator;
    return
  fi

  read -p "Enter the new name for the database: " newName

  # Check for null input
  if [[ "$newName" = '' ]]; then
    echo -e "\e[41mInvalid input, please enter a correct one\e[0m"
    read -p "press any key to continue...."
    elif [[ "newName"  =~ [/.:\|-] ]]; then
           echo -e "\e[41mYou can't enter these characters, please enter vaild name\e[0m"
           read -p "press any key to continue...."
   elif [[ "$newName" =~ ^[a-zA-Z] ]]; then
             # Rename the database
             mv "$oldName" "$newName"
             echo -e "\e[42mDatabase renamed successfully\e[0m"
             read -p "press any key to continue...."
     else
             echo -e "\e[41mDatabase name can't start with nimber or specialcharacter\e[0m"
                read -p "press any key to continue...."
  fi
  separator;
}

############################LIST DATBASES#################################################################
#list databases
function listDatabase {
        #no database exists
        if [[ $(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d' ) = '' ]]; then
                echo -e "\e[41mThere are no databases here\e[0m"
                read -p "press any key to continue...."
        #database exists
        else
                echo Databases:$'\n'$(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d')
                separator;
                read -p "press any key to continue...."
        fi
        separator;
}
################################CONNECT TO DATABASE##########################################################
#connect to database
function connectDB {
        #no database exists
        if [[ $(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d' ) = '' ]]; then
                echo -e "\e[41mThere are no databases here\e[0m"
                read -p "press ant key to continue...."
        #database exists
        else
                echo Databases:$'\n'$(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d')
                separator;

                read -p "Enter the Name of the database : " db
                #check if null input
                if [[ "$db" = '' ]];then
                        echo -e "\e[41mInvaild input, Please enter correct one\e[0m"
                        read -p "press any key to continue...."
                #check if database exists
                elif ! [[ -d "$db" ]]; then
                        echo -e "\e[41mThis database doesn't exists\e[0m"
                        read -p "press any key to continue...."
                #databaes exists
                else
                        cd "$db"
                        separator;
                        echo -e "\e[42mDatabase Successfully loaded\e[0m"
                        read -p "press any key to continue...."
                        table_menu
                fi
        fi
        separator;
}

############################DROP DATBASE###################################################################
#drop database
function dropDB {
        #display exists databases
        echo Databases:$'\n'$(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d')
        separator;
        read -p "Enter the name of Database : " db
        #check if null input
                if [[ "$db" = '' ]];then
                        echo -e "\e[41mInvaild input, Please enter correct one\e[0m"
                        read -p "press any key to continue...."
                #check if database exists
                elif ! [[ -d "$db" ]]; then
                        echo -e "\e[41mThis database doesn't exists\e[0m"
                        read -p "press any key to continue...."
                #databaes exists
                else
                        rm -rf "$db"
                        echo -e "\e[42m$db removed from your database\e[0m"
                        read -p "press any key to continue...."
                fi
                separator;
        }

#############################CREATE TABLE###################################################
function createTable {
        read -p "Enter the name of the table: " dbtable
        #check if the table exists
        if [[ -e "$dbtable" ]]; then
                echo -e "\e[41mThis table name exists\e[0m"
                read -p "press any key to continue..."
        #check if null input
        elif [[ $dbtable = "" ]]; then
                echo -e "\e[41mInvaild input, please enter correct one\e[0m"
                read -p "press any key to continue...."
        #check for special character
        elif [[ $dbtable =~ [/.:\|\-] ]]; then
                echo -e "\e[41Tble name can't contain special character\e[0m"
                read -p "press any key to continue...."
        # Check if the database name starts with a letter, has more than two letters
        elif [[ ! $dbtable =~ ^[a-zA-Z][a-zA-Z0-9_]{2,}$ || $dbtable =~ ^\s ]]; then
        echo -e "\e[41mInvalid name. The database name must have more than two letters.\e[0m"
        read -p "Press any key to continue...."

        elif [[ $dbtable =~ ^[a-zA-Z]+ ]]; then
                touch "$dbtable"
                CreateMetaData;
                echo -e "\e[42mTable create successfully..!\e[0m"
                read -p "press any key to continue..."
        else
                echo -e "\e[41mTable name can't start with number or sepical character\e[0m"
                read -p "press any key to continue...."
        fi
}
#################################CREATE METADATA##############################################################
function CreateMetaData {
        if [[ -f "$dbtable" ]]; then
                #ask for column num
                vaildMetaData=true
                while $vaildMetaData; do
                        echo -e "\e[44mHow many columns you want? \e[0m"
                        read num_column
                        if [[ "$num_column" = +([1-9])*([0-9]) ]]; then
                                vaildMetaData=false
                        else
                                echo -e "\e[41mInvaild input\e[0m"
                        fi
                done
        ################################################################
        #ask for pk
        vaildMetaData=true

 while $vaildMetaData; do
                echo -e "\e[44mEnter primary key name\e[0m"
                read pk_name
                if [[ $pk_name = "" ]]; then
                        echo -e "\e[41mInvaild input,please enter correct one\e[0m"
                        read -p "press any key to continue...."
                elif [[ $pk_name =~ [/.:\|\-] ]]; then
                        echo -e "\e[41mYou can't enter these characters => . / : - | \e[0m"
                        read -p "press any key to continue...."
                elif [[ $pk_name =~ ^[a-zA-Z] ]]; then
                        echo -n "$pk_name" >> "$dbtable"
                        echo -n "-" >> "$dbtable"
                        vaildMetaData=false
                else
                echo -e "\e[41mPrimary key can't start with numbers or special character\e[0m"
                fi
  done
        ####################
        #pk datatype
        vaildMetaData=true
        while $vaildMetaData; do
                echo -e "\e[44mEnter primary key datatype\e[0m"
                select choice in "int" "str"; do
                        if [[ "$REPLY" = "1" || "$REPLY" = "2" ]]; then
                                echo -n "$choice" >> "$dbtable"
echo -n "-" >> "$dbtable"
                                vaildMetaData=false
                        else
                                echo -e "\e[41minvaild choice\e[0m"
                        fi
                        break
                done
        done
        #####################
        #pk size
        validMetaData=true
        while $validMetaData; do
                echo -e "\e[44mEnter primary key size\e[0m"
                read size
                if [[ "$size" = +([1-9])*([0-9]) ]]; then
                        echo -n "$size" >> "$dbtable"
                        echo -n ":" >> "$dbtable"
                        validMetaData=false
                else
                        echo -e "\e[41minvalid input\e[0m"
                fi
        done

        #################
        #loop over number of entered num_columns
 for (( i = 1; i < num_column; i++ )); do
                validMetaData=true
                while $validMetaData; do
                        echo -e "\e[46mEnter column $((i+1)) name\e[0m"
                        read column_name
                        if [[ $column_name = "" ]]; then
                                echo -e "\e[41mInvalid input, please enter a non-empty value\e[0m"
                                read -p "Press any key to continue...."
                                elif [[ $column_name =~ [/.:\|\-] ]]; then
                                        echo -e "\e[41mInvalid input, please avoid special characters like / . : | -\e[0m"


                                         read -p "Press any key to continue...."
                               elif [[ $column_name =~ ^[a-zA-Z] ]]; then
                                                 echo -n "$column_name" >> "$dbtable"
                                                 echo -n "-" >> "$dbtable"
                                                 validMetaData=false
                                 else
                                                         echo -e "\e[41mColumn name can't start with numbers or special characters\e[0m"
                        fi
                done
        ###############
                #column datatype
                validMetaData=true
                while $validMetaData; do
                        echo -e "\e[46menter column $[i+1] datatype\e[0m"
 select choice in "int" "str"; do
                                if [[ "$REPLY" = "1" || "$REPLY" = "2" ]]; then
                                        echo -n "$choice" >> "$dbtable"
                                       echo -n "-" >> "$dbtable"
                                        validMetaData=false
                                else
                                        echo -e "\e[41minvalid choice\e[0m"
                                fi
                                break
                        done
                done
                ########################
                #column size
                validMetaData=true
                while $validMetaData; do
                        echo -e "\e[46menter column $[i+1] size please\e[0m"
                        read size
                        if [[ "$size" = +([1-9])*([0-9]) ]]; then
                                echo -n "$size" >> "$dbtable"
                                ############
                                #if last column
                                if [[ i -eq $num_column-1 ]]; then
                                        echo $'\n' >> "$dbtable"
                                        echo -e "\n\e[42mTable created successfully..!\e[0m"
 read -p "press any key to continue...."
                 validMetaData=false
                                else
                                        echo -n ":" >> "$dbtable"
                                fi
                                validMetaData=false
                        else
                                echo -e "\e[41mInvaild input\e[0m"
                        fi
                done
        done
else
        echo -e "\e[41mInvaild input\e[0m"
        read -p "press any key to continue..."
        fi


}
############################# list tables ####################################################
function listTables {
    tables=$(ls -p | grep -v /)
    if [[ -z $tables ]]; then
        echo -e "\e[41mThere are no tables in this database.\e[0m"
    else
        echo -e "\e[42mExisting Tables:\e[0m"
        echo "$tables"
    fi
    read -p "Press any key to continue...."
}
##############################INSERT DATA #############################################
function insertData {
        #choose table
        read -p "Enter the name of the table: " dbtable
        ###############################
        #check if table exists
        if ! [[ -f "$dbtable" ]]; then
                echo -e "\e[41mthis table doesn't exist\e[0m"
                read -p "press any key to continue..."
                ##########################
        else
                #table exists
                insertingData=true
                while $insertingData; do
                        #enter pk
                        echo -e "enter value of primary key \"\e[44m$(head -1 "$dbtable" | cut -d ':' -f1 | awk -F "-" '{print $1}')\e[0m\" of type \e[44m$(head -1 "$dbtable" | cut -d ':' -f1 | awk -F "-" '{print $2}')\e[0m and size \e[44m$(head -1 "$dbtable" | cut -d ':' -f1 | awk -F "-" '{print $3}')\e[0m"
                        read
                        #match data&size
                        check_type=$(check_dataType "$REPLY" "$dbtable" 1)
                        check_size=$(check_size "$REPLY" "$dbtable" 1)
                        #=> print all records except first record
                        pk_used=$(cut -d ':' -f1 "$dbtable" | awk '{if(NR != 1) print $0}' | grep -x -e "$REPLY")
                        #################################
                        #null input
                        if [[ "$REPLY" == '' ]]; then
                                echo -e "\e[41mNO Input\e[0m"
                        #special character
                        elif [[ "$REPLY" =~ [/.:\|\-] ]]; then
                                echo -e "\e[41mYou can't enter these characters => . / : - | \e[0m"
                        #not matching datatype
                        elif [[ "$check_type" == 0 ]]; then
                                echo -e "\e[41minvaild datatype\e[0m"
                        #not matching size
                        elif [[ "$check_size" == 0 ]]; then
                                echo -e "\e[41minvaild size\e[0m"
                        #if primary key exists
                        elif ! [[ "$pk_used" == '' ]]; then
                                echo -e "\e[41mthis primary key is already used\e[0m"
                        #primary key is vaild
                        else
                                echo -n "$REPLY" >> "$dbtable"
                                echo -n ':' >> "$dbtable"
                                # to get number of columns in table
                                num_col=$(head -1 "$dbtable" | awk -F: '{print NF}')
                                #loop over columns to enter their data after pk
                                for (( i = 2; i <= num_col; i++ )); do
                                        #enter other data
                                        insertingOtherData=true
                                        while $insertingOtherData; do
                                                echo -e "enter value of\"\e[44m$(head -1 "$dbtable" | cut -d ':' -f$i | awk -F "-" 'BEGIN { RS = ":" } {print $1}')\e[0m\" of type \e[44m$(head -1 "$dbtable" | cut -d ':' -f$i | awk -F "-" 'BEGIN { RS = ":" } {print $2}')\e[0m and size \e[44m$(head -1 "$dbtable" | cut -d ':' -f$i | awk -F "-" 'BEGIN { RS = ":" } {print $3}')\e[0m"
                                                read
                                                # match data with its col datatype & size
                                        check_type=$(check_dataType "$REPLY" "$dbtable" "$i")
                                        check_size=$(check_size "$REPLY" "$dbtable" "$i" )
                                         #not matching datatype
                                        if [[ "$check_type" == 0 ]]; then
                                            echo -e "\e[41minvaild datatype\e[0m"
                                        #not matching size
                                        elif [[ "$check_size" == 0 ]]; then                                                                     echo -e "\e[41minvaild size\e[0m"
                                   elif [[ "$REPLY" =~ [/.:\|\-] ]]; then
                                             echo -e "\e[41mYou can't enter these characters => . / : - | \e[0m"
                                             #vaild input
                                     else
                                             # if last column
                                             if [[ "$i" -eq "$num_col" ]]; then
                                                     echo "$REPLY" >> "$dbtable"
                                                     insertingOtherData=false
                                                     insertingData=false
                                                 echo -e "\e[42mInput inserted successfully\e[0m"
                                         else
                                                 #next column
                                                 echo -n "$REPLY": >> "$dbtable"
                                                 insertingOtherData=false
                                             fi
                                        fi
                                done
                        done
                        fi
                done
                read -p "press any key to continue...."
        fi
}
##################################DISPLAY TABLE#######################################################
# Display Table function
function displayTable {
    # Prompt user for table name
    read -p "Enter table name: " dbtable

    # Check if the table exists
    if ! [[ -f "$dbtable" ]]; then
        # Table does not exist
        echo -e "\e[41mthis table doesn't exist\e[0m"
        read -p "Press any key to continue..."
    else
        # Table exists
        # Display table's header
        echo "--------------------------------------------------------------------------"
        head -1 "$dbtable" | awk 'BEGIN{ RS = ":"; FS = "-" } {printf "%-20s", $1}'
        echo -e "\n--------------------------------------------------------------------------"

        # Display table's data, excluding the header
        sed '1d' "$dbtable" | awk -F: 'BEGIN{OFS="\t"} {for(n = 1; n <= NF; n++) printf "%-20s", $n; print ""}'

        # Prompt user to continue
        read -p "Press any key to continue..."
    fi
}

#################################DISPLAY RECORD#######################################################
#display by row
function displayRow {
    read -p "Enter name of the table: " dbtable

    # Check if the table exists
    if ! [[ -f "$dbtable" ]]; then
        # Table does not exist
        echo -e "\e[41mError: This table doesn't exist.\e[0m"
        read -p "Press any key to continue..."
    else
        
   # Table exists
        # Enter primary key information
        echo "Enter primary key \"$(head -1 "$dbtable" | cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$dbtable" | cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$dbtable" | cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $3}') of the record"
        read

        # Find the record number for the given primary key
        recordNum=$(cut -d ':' -f1 "$dbtable" | sed '1d' | grep -x -n -e "$REPLY" | cut -d':' -f1)

        # Null input
        if [[ -z "$REPLY" ]]; then
            echo -e "\e[41mError: No input provided.\e[0m"
        # Record does not exist
        elif [[ -z "$recordNum" ]]; then
            echo -e "\e[41mError: This primary key doesn't exist.\e[0m"
        else
            # Record exists
            let recordNum=$recordNum+1
            num_col=$(head -1 "$dbtable" | awk -F: '{print NF}')

            # Display fields and values of this record
            echo -e "\e[1;35mFields and values of this record:\e[0m"
            for (( i = 2; i <= num_col; i++ )); do
                field_name=$(head -1 $dbtable | cut -d ':' -f$i | awk -F "-" 'BEGIN { RS = ":" } {print $1}')
                field_value=$(sed -n "${recordNum}p" "$dbtable" | cut -d: -f$i)
                echo -e "\e[1;93m$field_name:\e[0m \e[36m$field_value\e[0m"

            done
        fi

        read -p "Press any key to continue..."
    fi
}
#################################UPDATE TABLE######################################################################
# Update Table
function updateTable {
        # choose table
        read -p "enter name of the table: " dbtable
        # not exist
        if ! [[ -f "$dbtable" ]]; then
                echo -e "\e[41mthis table doesn\'t exist\e[0m"
                read -p "press any key to continue..." 
        else
                # table exists
                # enter pk
                echo enter primary key \"$(head -1 "$dbtable" | cut -d ':' -f1 |\
                awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$dbtable"\
                | cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$dbtable"\
                | cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $3}') of the record
                read

                recordNum=$(cut -d ':' -f1 "$dbtable" | sed '1d'\
                | grep -x -n -e "$REPLY" | cut -d':' -f1)
              
                # null input
                if [[ "$REPLY" == '' ]]; then
                        echo -e "\e[41mNO input\e[0m"
     # record not exists
                elif [[ "$recordNum" = '' ]]; then
                        echo -e "\e[41mthis primary key doesn't exist\e[0m"
                # record exists
                else
                        let recordNum=$recordNum+1
                        # to get number of columns in table
                        num_col=$(head -1 "$dbtable" | awk -F: '{print NF}')
                        # to show the other values of record
                        separator;
                        echo -e "\e[42mother fields and values of this record:\e[0m"
                        for (( i = 2; i <= num_col; i++ )); do
                                        echo \"$(head -1 $dbtable | cut -d ':' -f$i |\
                                        awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$dbtable" | cut -d ':' -f$i |\
                                        awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$dbtable" | cut -d ':' -f$i |\
                                        awk -F "-" 'BEGIN { RS = ":" } {print $3}'): $(sed -n "${recordNum}p" "$dbtable" | cut -d: -f$i)
                        done
                        separator;
                        # to show the other fields' names of this record
                        echo -e "\e[42mrecord fields:\e[0m"
                        option=$(head -1 $dbtable | awk 'BEGIN{ RS = ":"; FS = "-" } {print $1}')
                        echo "$option"
                        getFieldName=true
                        while $getFieldName; do
                                separator;
                                read -p "enter field name to update"
                                # null input
                                if [[ "$REPLY" = '' ]]; then
                                        echo -e "\e[41minvalid input\e[0m"
                                # field name not exists
                                elif [[ $(echo "$option" | grep -x "$REPLY") = "" ]]; then
                                        echo -e "\e[41mno such field with that name, please enter a valid name\e[0m"
                                # field name exists
                                else
                                        # get field number
                                        fieldnum=$(head -1 "$dbtable" | awk 'BEGIN{ RS = ":"; FS = "-" } {print $1}'\
                                        | grep -x -n "$REPLY" | cut -d: -f1)
                                        updatingField=true
                                        while $updatingField; do
                                                # updating field's primary key
                                                if [[ "$fieldnum" = 1 ]]; then
                                                        echo enter primary key \"$(head -1 "$dbtable" | cut -d ':' -f1 |\
                                                        awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$dbtable"\
                                                        | cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$dbtable"\
                                                        | cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $3}')

                                                        read
                                                        check_type=$(check_dataType "$REPLY" "$dbtable" 1)
                                                        check_size=$(check_size "$REPLY" "$dbtable" 1)
                                                        pk_used=$(cut -d ':' -f1 "$dbtable" | awk '{if(NR != 1) print $0}' | grep -x -e "$REPLY")
                                                        # null input
                                                        if [[ "$REPLY" == '' ]]; then
                                                                echo -e "\e[41mno input, id can't be null\e[0m"
                                                        #match datatype
                                                        elif [[ "$check_type" == 0 ]]; then
                                                                echo -e "\e[41minvalid input\e[0m"
                                                        # not matching size
                                                        elif [[ "$check_size" == 0 ]]; then
                                                                echo -e "\e[41minvalid size\e[0m"
                                                        # pk is used
                                                        elif ! [[ "$pk_used" == '' ]]; then
                                                                echo -e "\e[41mthis primary key already used\e[0m"
                                                        # pk is valid
                                                        else
                                                                awk -v fn="$fieldnum" -v rn="$recordNum" -v nv="$REPLY"\
                                                                'BEGIN { FS = OFS = ":" } { if(NR == rn)        $fn = nv } 1' "$dbtable"\
                                                                > "$dbtable".new && rm "$dbtable" && mv "$dbtable".new "$dbtable"
                                                                updatingField=false
                                                                getFieldName=false
                                                        fi
                                                # updating other field 
                                                else
                                                        updatingField=true
                                                        while $updatingField ; do
                                                                echo enter \"$(head -1 $dbtable | cut -d ':' -f$fieldnum |\
                                                                awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$dbtable" | cut -d ':' -f$fieldnum |\
                                                                awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$dbtable" | cut -d ':' -f$fieldnum |\
                                                                awk -F "-" 'BEGIN { RS = ":" } {print $3}')
                                                                read
                                                                check_type=$(check_dataType "$REPLY" "$dbtable" "$fieldnum")
                                                                check_size=$(check_size "$REPLY" "$dbtable" "$fieldnum")
                                                                # match datatype
                                                                if [[ "$check_type" == 0 ]]; then
                                                                        echo -e "\e[41mentry invalid\e[0m"
                                                                # not matching size
                                                                elif [[ "$check_size" == 0 ]]; then
                                                                        echo -e "\e[41mentry size invalid\e[0m"
                                                                # entry is valid
                                                                else
                                                                        awk -v fn="$fieldnum" -v rn="$recordNum" -v nv="$REPLY"\
                                                                        'BEGIN { FS = OFS = ":" } { if(NR == rn)        $fn = nv } 1' "$dbtable"\
                                                                        > "$dbtable".new && rm "$dbtable" && mv "$dbtable".new "$dbtable"
                                                                        updatingField=false
                                                                        getFieldName=false
                                                                fi
                                                        done
                                                fi
                                        done
                                        echo -e "\e[42mfield updated successfully\e[0m"
                                fi
                        done
                fi
                echo press any key
                read
        fi
}
##############################DELETE TABLES ###############################################################
function delete_table {
        read -p " enter the name of table to delete : " dbtable
        if ! [[ -f "$dbtable" ]]; then
                echo -e "\e[41mthis table doesn't exist\e[0m"
                read -p "press any key"
        else
                rm "$dbtable"
                echo -e "\e[42mtable deleted successfully..!\e[0m"
                read -p "press any key to continue..."
        fi
}
#############################DELETE BY ROW#############################################################
function deleteRecord {
    # Choose table
    read -p "Enter the name of the table:" dbtable

    # Check if the table exists
    if ! [[ -f "$dbtable" ]]; then
        echo -e "\e[41mThis table doesn't exist\e[0m"
        read -p "Press any key to continue..."
    else
        # Table exists

        # Enter primary key details
        tableInfo=$(head -1 "$dbtable" | cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $1, $2, $3}')
        echo -e "Enter the primary key \"$tableInfo\" of the record to delete:"

        read primaryKey

        # Get the number of the record with the provided primary key
        recordNum=$(cut -d ':' -f1 "$dbtable" | awk '{if(NR != 1) print $0}' | grep -x -n -e "$primaryKey" | cut -d':' -f1)

        # Null input
        if [[ "$primaryKey" == '' ]]; then
            echo -e "\e[41mNO input\e[0m"

        # Record not exists
        elif [[ "$recordNum" = '' ]]; then
            echo -e "\e[41mThis primary key doesn't exist\e[0m"

        # Record exists
        else
            let recordNum=$recordNum+1 # Adjust for 1-based index (sed)
            sed -i "${recordNum}d" "$dbtable"
            echo -e "\e[42mRecord deleted successfully\e[0m"
        fi

        echo "Press any key to continue..."
        read
    fi
}
#########################HLEPFER FUNCTIONS##############################################
##########################CHECKDATATYPE#################################################################
function check_dataType {
        datatype=$(head -1 $2 | cut -d ':' -f$3 | awk -F "-" 'BEGIN { RS = ":" } {print $2}')
        if [[ "$1" = '' ]]; then
                echo 1
        elif [[ "$1" = -?(0) ]]; then
                echo 0 # error!
        elif [[ "$1" = ?(-)+([0-9])?(.)*([0-9]) ]]; then
                if [[ $datatype == int ]]; then
                        # datatype integer and the input is integer
                        echo 1
                else
                        # datatype string and input is integer
                        echo 0
                fi
        else
                if [[ $datatype == int ]]; then
                        # datatype integer and input is string
                        echo 0 # error!
                else
                        # datatype string and input is string
                        echo 1
                fi
        fi
}
#########################CHECK SIZE#######################################################
function check_size {
        datasize=$(head -1 $2 | cut -d ':' -f$3 | awk -F "-" 'BEGIN { RS = ":" } {print $3}')
        if [[ "${#1}" -le $datasize ]]; then
                echo 1
        else
                echo 0 # error
        fi
}
#############################print separator between lines#######################################
function separator {
  echo -e "\n---------------------------------------------------------------------------------------------------\n";
}

######################RUN THE PROGRAM##########################################################
introscreen
