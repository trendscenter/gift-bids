# In grip web workflow: upload demo_input3neuromark_sbm.zip and gift-bids-main.zip
# (github gets permission problems for gift-bids)
# Manual steps:
# start VM 
# Open terminal
mkdir -p ~/vm_work/code
cd ~/vm_work/code
#not working git has no permission - git clone https://github.com/trendscenter/gift-bids 
cp /mnt/vm-shared-storage/gift-bids-main.zip .
unzip gift-bids-main.zip
rm -rf __MACOSX gift-bids-main.zip
cd /mnt/vm-shared-storage
unzip demo_input3neuromark_sbm.zip
docker pull trends/gift-bids:v4.0.5.3
docker pull nipreps/fmriprep
mkdir ~/vm_work/out
cd ~/vm_work/code/gift-bids-main/demo/hostfiles/docker
./docker_neuromark_pet_sep_sub_files.sh /mnt/vm-shared-storage/demo_input3neuromark_sbm /home/mc5v/vm_work/out /home/mc5v/vm_work/code/gift-bids-main/demo/cfg
cd ~/vm_work/out
sed -i 's/,$//' GIGICA_group_loading_coeff_.csv #remove commas at line ends
sed -i '/^,*$/d' GIGICA_group_loading_coeff_.csv #remove last line of commas
awk -F',' 'NR==1{ for(i=1;i<=NF;i++){ printf "IC%03d,", i }  print ""} {print}' GIGICA_group_loading_coeff_.csv > GIGICA_group_loading_coeff_cols.csv
sed -i 's/,$//' GIGICA_group_loading_coeff_cols.csv #remove commas at end for header too
mkdir -p /mnt/vm-shared-storage/projects/022026
cp -r * /mnt/vm-shared-storage/projects/022026/.

# Final manual steps:
# goto csv file in workflow files and click the link [see all] to see files properly
# expand the tree to projects/022026
# check box for GIGICA_group_loading_coeff_cols.csv and convert click the 3 dots to the right of file to see menu item "Convert to Table" (converting file to sqlite3 table)
# A wizard to convert csv to table appears, where you fill in TestTable in the Table Name field instructions. Everything else in the wizard may be left untouched, but make sure it looks okay before clicking [Done] (making table TestTable).
# A progress screen appears and you wait until Circle shows 100% (also saying your table was successfully created) and you may then hit [Done]
# The following file should have been created: /mnt/vm-shared-storage/database/ceierud/GIGICA_group_loading_coeff_cols.sqlite
# Then open Jupyter clicking [Start App] and select [notebook python 3.1 environment] 
# Since no python environments are good enough to connect to database we need to create our own jypyter environment with db capabilities adding the following to first cell (takes perhaps 5min):
!mkdir -p ~/conda_envs 
!/opt/conda/bin/conda create -y -p ~/conda_envs/pydb python=3.11 pandas sqlalchemy psycopg2 ipykernel
# After perhaps 4 minutes you have a tone of text output and at the botton it says To Activate this environment use conda activate /home/jovyan/conda_envs/pydb
# On menu (at top) click Kernel/Restart Kernel
# At next cell run following: !/opt/conda/bin/conda run -p /home/jovyan/conda_envs/pydb python -m ipykernel install --user --name pydb --display-name "Python 3 (pydb)"
# close your entire Jupyter tab
# Start Jupyter again and now you should have a new Notebook Kernel called Python 3 (pydb) for Notebooks, which you should click
# Now paste following in your first Jupyter cell:
import sqlite3
import pandas as pd
db_path = "/home/jovyan/work/database/ceierud/GIGICA_group_loading_coeff_cols.sqlite"
con = sqlite3.connect(db_path)
df = pd.read_sql('SELECT * FROM TestTable;', con)
pd.read_sql('SELECT * FROM TestTable LIMIT 100;', con)
# You should see a Table with row numbers 0 to 29, representing the 30 subjects and the 19 columns at the top labeled IC0XX
# Go back to Home Tab and click [Stop App] for Jupyter and [Stop VM]
 
