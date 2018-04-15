if [ $EUID != 0 ]
then
  echo "Please run this script as root so as to see all details! Better run with sudo."
  exit 1
fi
#Creating a directory if it doesn't exist to store reports first, for easy maintenance.
if [ ! -d ./reports ]
then
  mkdir ./reports
fi
while read -r line; do
   # printf "<%s>\n" "$line"
   git clone "Akhil:git@$line. Wellsfargo.com"
   cd $line
   # git clone "$line" "$localFolder"
   read -p "Give branch name as input? " branch
   git checkout $branch
   printf "<%s>\n" "$branch is checked"
   #Generating HTML file
   html="./reports/'$line'_'$branch'_Report-`hostname`-`date +%y%m%d`-`date +%H%M`.html"
   email_add="change this to yours"
   echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">" >> $html
   echo "<html>" >> $html
   echo "<link rel="stylesheet" href="https://unpkg.com/purecss@0.6.2/build/pure-min.css">" >> $html
   echo "<style type="text/css">" >> $html
   echo "td{ padding:0 15px 0 15px;} </style>" >> $html
   echo "<body>" >> $html
   echo "<fieldset>" >> $html
   echo "<center>" >> $html
   echo "<h2> Report of $line" >> $html
   echo "<h3><legend>Script authored by Akhil Nalumachu</legend></h3>" >> $html
   echo "</center>" >> $html
   echo "</fieldset>" >> $html
   echo "<br>" >> $html
   echo "<center>" >> $html
   echo "<h2>Properties missing are : </h2>" >> $html
   echo "<br>" >> $html

   echo "<h1>Properties missing in DevAppProperties.groovy <h2>" >> $html
   while read -r name es value; do
   		for i in value
		do
		   while read -r name2 es2 value2; do
			    if [ "$name2" == "$i"]; then
			    	continue;
			    fi
			    echo "$i" >> $html
			    #echo "<tr>" >> $html
				# echo "<td>$name $es $value</td>" >> $html
				# echo "<td></td>" >> $html
				# echo "<td>$name2 $es2 $value2</td>" >> $html
				# echo "</tr>" >> $html
		    done < .DevAppProperties.groovy
		done
   done < DevAppProperties.txt

   echo "<h1>Properties missing in Env1Properties.groovy <h2>" >> $html
   while read -r name es value; do
   		for i in value
		do
		   while read -r name2 es2 value2; do
			    if [ "$name2" == "$i"]; then
			    	continue;
			    fi
			    echo "$i" >> $html
		    done < .Env1Properties.groovy
		done
   done < EnvSpecificProperties.txt

   echo "<h1>Properties missing in Env2Properties.groovy <h2>" >> $html
   while read -r name es value; do
		for i in value
		do
		   while read -r name2 es2 value2; do
			    if [ "$name2" == "$i"]; then
			    	continue;
			    fi
			    echo "$i" >> $html
		    done < .Env2Properties.groovy
		done
   done < EnvSpecificProperties.txt
   echo "</body>" >> $html
   echo "</html>" >> $html
   echo "Report has been generated in ./reports with file-name = $html. Report has also been sent to $email_add."
   #Sending Email to the user
   cat $html | mail -s "`hostname` - Repos Properties Report" -a "MIME-Version: 1.0" -a "Content-Type: text/html" -a "From: Akhil Nalumachu <akhil.nalumachu@gamil.com>" $email_add
done < Repos.txt
