Bootstrap: docker
From: tin6150/metabolic

# Singularity def, wrap around docker tin6150/metabolic
# but may not work yet, cuz somehow docker hub isn't allowing creating new repos at this time.

%post
	touch "_ROOT_DIR_OF_CONTAINER_" ## also is "_CURRENT_DIR_CONTAINER_BUILD" 
	date >> _ROOT_DIR_OF_CONTAINER_
	echo "Singularity def 2019.1219.0725" >> _ROOT_DIR_OF_CONTAINER_
	echo "Singularity def 2019.1222.2125 (timestamp update only)" >> _ROOT_DIR_OF_CONTAINER_

	# docker run as root, but singularity may run as user, so adding these hacks here
	mkdir -p /global/scratch/tin
	mkdir -p /global/home/users/tin
	mkdir -p /home/tin
	mkdir -p /home/tmp
	mkdir -p /Downloads
	chown    43143 /global/scratch/tin
	chown    43143 /global/home/users/tin
	chown -R 43143 /home
	#chown -R 43143 /home/tin
	chown -R 43143 /opt
	chown -R 43143 /Downloads
	chmod 1777 /home/tmp

%runscript
    #TZ=PST8PDT /bin/tcsh
    #/bin/bash -i 
    #xx source /etc/bashrc && /Downloads/CMAQ/CMAQ-4.5-ADJ-LAJB_tutorial/code/CMAQ-4.5-ADJ-LAJB/./built_gcc_gfortran_serial_SAPRC99ROS/bin/CCTM/cctm
	LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/conda/lib PATH=${PATH}:/opt/conda/bin /bin/bash -i

	

%help
    Metabolic from https://github.com/AnantharamanLab/METABOLIC
    
# Pull and run via singularity-hub:
# singularity pull shub://tin6150/metabolic
# singularity pull --name metabolic_b1219.sif shub://tin6150/metabolic
# singularity shell metabolic.sif

# manual build cmd:
# sudo /opt/singularity-2.6/bin/singularity build --writable metabolic_b1219a.img Singularity 2>&1  | tee singularity_build.log
#
# eg run cmd on bofh w/ singularity 2.6.2:
#      /opt/singularity-2.6/bin/singularity run     metabolic_b1219a.img
# sudo /opt/singularity-2.6/bin/singularity exec -w metabolic_b1219a.img /bin/tcsh

# eg run cmd on lrc, singularity 2.6-dist (maybe locally compiled)
#      singularity shell -w -B /global/scratch/tin ./metabolic_b1219a.img
#
# dirac1 has singularity singularity-3.2.1-1.el7.x86_64 

# vim: nosmartindent tabstop=4 noexpandtab shiftwidth=4
