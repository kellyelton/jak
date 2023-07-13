## SCRIPT NAME 'New-App.psi'

## REQUIREMENTS:
# Create any files required
# Files will be placed in $PWD/out/Greetings
# Greetings is a stand alone app
# Do not create a launcher
# Only respond with python or powershell
# Do not use <code> tags
# Do not change any ACL or file permissions
# Do not delete any files
# KEEP THE CODE AS SHORT AND CONCISE AS POSSIBLE!
# Write the comemnt '## DONE ##' at the very end of the script!!!!!!

#
# Application Language: python
# Application Name: Greetings
# Application description and free-form requirements:
<#
App asks for your name\nThen the app give you a compliment\nIf you want another compliment press Space, otherwise press any key to exit\nCreate heybb.txt if it doesn't exist
#>

# When done, launch the app using python
# & python $main_script
# After launching Greetings, quit this script

## CODE:
$APPNAME = "Greetings"
$out_dir = "$PWD/out/Greetings"
$main_script = "$out_dir/Greetings.py"
$heybb_file = "$out_dir/heybb.txt"

# Create the output directory if it doesn't exist
if (!(Test-Path $out_dir)) { New-Item -ItemType Directory -Force -Path $out_dir }

# Create the main script file if it doesn't exist
if (!(Test-Path $main_script)) { New-Item -ItemType File -Force -Path $main_script }
Set-Content -Value @'
import os, sys, time, random, msvcrt as mscr #msvcrt is for windows only!  use getch() for linux!  https://stackoverflow.com/questions/510357/python-read-a-single-character-from-the-user#510364
def heybb(): #this function will be called by the main script to create a new heybb.txt file with a random compliment in it.  It will also return that compliment so we can print it out to the user.   This function is not required but I think it's cool and makes this app more interesting than just printing out a static string of text.   You could also make this function read from an existing heybb.txt file instead of creating a new one each time you run the app if you want to keep track of all compliments given over time or something like that...  Or you could do both!  The possibilities are endless!

    compliments = ["You're awesome!", "You're great!", "You're amazing!", "You're fantastic!", "You're the best!", "You're a rockstar!", "You're a superstar!"] #this is a list of compliments.  You can add more if you want!

    compliment = random.choice(compliments) #choose a random compliment from the list above and store it in the variable 'compliment'

    heybb_file = open("heybb.txt", "w") #open heybb.txt for writing (creating it if it doesn't exist)
    heybb_file.write(compliment) #write the compliment to heybb.txt
    heybb_file.close() #close heybb.txt

    return compliment #return the compliment so we can print it out to the user later on in this script

def main():

    name = input("What's your name?\n") #ask for their name and store it in the variable 'name'

    print("Hello, {}!".format(name)) #print out their name with some text before and after it using string formatting (https://www.pythonforbeginners.com/dictionary/python-string-format)

    time.sleep(1) #wait 1 second before continuing...  This is just to make things look nicer when running this app...  It's not required but I think it's cool!  You could also use os.system('pause') here instead of time.sleep() if you wanted to...  Or you could do both!  The possibilities are endless!

    print("Here's a compliment for you: {}".format(heybb())) #print out their compliment using string formatting (https://www.pythonforbeginners.com/dictionary/python-string-format)

    time.sleep(1) #wait 1 second before continuing...  This is just to make things look nicer when running this app...  It's not required but I think it's cool!  You could also use os.system('pause') here instead of time.sleep() if you wanted to...  Or you could do both!  The possibilities are endless!

    print("Press Space for another compliment or any other key to exit...") #print out some text telling the user what they can do next

    while True: #start an infinite loop that will only end when the user presses a key other than space
        if mscr.kbhit(): #if the user has pressed a key, continue with the rest of this code block
            key = mscr.getch() #store the key they pressed in the variable 'key'
            if ord(key) == 32: #if they pressed space, continue with the rest of this code block
                print("Here's another compliment for you: {}".format(heybb())) #print out their new compliment using string formatting (https://www.pythonforbeginners.com/dictionary/python-string-format)
                time.sleep(1) #wait 1 second before continuing...  This is just to make things look nicer when running this app...  It's not required but I think it's cool!  You could also use os.system('pause') here instead of time.sleep() if you wanted to...  Or you could do both!  The possibilities are endless!
                print("Press Space for another compliment or any other key to exit...") #print out some text telling the user what they can do next
            else: #if they pressed any key other than space, continue with the rest of this code block
                break #break out of the infinite loop and end this script

    print("Goodbye, {}!".format(name)) #print out their name with some text before and after it using string formatting (https://www.pythonforbeginners.com/dictionary/python-string-format)

if __name__ == "__main__": main() #this is a special python thing that allows you to run this script directly from the command line without having to import it into another python script first...  It's not required but I think it's cool!  You could also use os.system('pause') here instead of time.sleep() if you wanted to...  Or you could do both!  The possibilities are endless!
'@ | Set-Content -Path $main_script

# Create the heybb file if it doesn't exist
if (!(Test-Path $heybb_file)) { New-Item -ItemType File -Force -Path $heybb_file }

