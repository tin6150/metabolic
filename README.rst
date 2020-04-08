Metabolic
~~~~~~~~~

This project 
( https://github.com/tin6150/metabolic.git )
is the containerization of AnantharamanLab/METABOLIC
( https://github.com/AnantharamanLab/METABOLIC ).

Quick Start for interactive use of Metabolic via Singularity container 
======================================================================

::

	singularity pull --name metabolic.sif shub://tin6150/metabolic
	./metabolic.sif

The above commands will drop you into a shell inside the container, 
where the metabolic program and all its dependencies are installed.
Host system need to have Singularity 3.2 installed.

The metabolic software is installed under /opt/METABOLIC
5_genomes_test has been extracted under this directory as well.
/usr/bin/xpdf could be used to view the generated PDF.

To invoke METABOLIC-G.pl from the interactive shell inside the container::

	cd $HOME    
	cd /global/scratch/$USER   # please use luster scratch dir if avail
	tar xfz /opt/METABOLIC/5_genomes_test.tgz
	perl /opt/METABOLIC/METABOLIC-G.pl -t 34 -in-gn ./5_genomes_test/Genome_files -o ./metabolic_out -m /opt/METABOLIC/

	# options are:
	# -in-gn [folder with all your genomes] 
	# -t [number of threads]  # adjust per lscpu ( though even at 34 threads on 36-core machine, load average seems to remain below 8.)
	# -o [METABOLIC output folder] 
	# -m your/path/to/put/METABOLIC-folder

REMEMBER: content stored INSIDE the container is ephemeral and lost when container is restarted.  Save your data to a mounted volume shared with the host, eg $HOME, or scp the data out before closing/ending the container session.


Running Metabolics as batch job (eg in a slurm script)
------------------------------------------------------

::

	export BASE=/global/scratch/$USER ;
	singularity exec metabolic.sif perl /opt/METABOLIC/METABOLIC-G.pl -t 34 -in-gn $BASE/5_genomes_test/Genome_files -o $BASE/metabolic_out -m /opt/METABOLIC/



Starting the Metabolic container via Docker
===========================================

Interactive run (note that content are not saved into the image unless one run ``docker commit ...``::

	docker run -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME:/tmp/home --user=$(id -u):$(id -g)  tin6150/metabolic
	cd /opt/METABOLIC
	perl /opt/METABOLIC/METABOLIC-G.pl -t 34 -in-gn ./5_genomes_test/Genome_files -o /tmp/home/metabolic_out -m /opt/METABOLIC/
	xpdf /tmp/home/metabolic_out/R_output/GCA_005222525.1_ASM522252v1_genomic.draw_nitrogen_cycle_single.pdf
	# scp is also available to copy files out
	# Above depends on root being able to write to $HOME/metabolic_out.  change -v to other dir as needed.

Non interactive, scriptable run::

	The following should work in theory, but some kernel issues is preventing -v and --entrypoint in both working at the same time
	May have to wait till kernel update...
	sudo docker run  -v $HOME:/tmp/home --entrypoint "perl /opt/METABOLIC/METABOLIC-G.pl -t 34 -in-gn /5_genomes_test/Genome_files -o /tmp/home/metabolic_out -m /opt/METABOLIC/" tin6150/metabolic 



Info about the Metabolic container
==================================

A docker container is build first, done as 3 cascading parts:

1. Dockerfile.base [tin6150/base4metabolic]: Debian Linux with R 3.6.2 (and CRAN libs) and number of .deb packages to satisfy dependencies (Hmmer, etc)

2. Dockerfile.perl [tin6150/perl4metabolic]: add BioPerl and other CPAN libraries

3. Dockerfile.metabolic [tin6150/metabolic]: add miniconda, sambamba, and METABOLIC.
    - run_setup.sh has been run, software is installed under /opt/METABOLIC .
    - 5_genomes_test has been extracted under this directory as well, but dir by default is not writable.

4. gtdbtk binary was installed, but not the database.  
   To use it, see "DB for gtdbtk" below.

5. /usr/bin/xpdf and /usr/bin/scp are available to view resulting pdf or copy data out of the container, if needed.

The last docker container is then converted into a Singularity container for use by end user without priviledged access.


Container links
===============

* https://hub.docker.com/repository/docker/tin6150/metabolic
* https://singularity-hub.org/collections/3934


Build Commands
==============

::

		docker build -t tin6150/base4metabolic  -f Dockerfile.base       .  | tee Dockerfile.base.log 
		docker build -t tin6150/perl4metabolic  -f Dockerfile.perl       .  | tee Dockerfile.perl.log 
		docker build -t tin6150/metabolic       -f Dockerfile.metabolic  .  | tee Dockerfile.log 

		Optional conversion to Singularity to run in HPC environment:
		sudo /opt/singularity-2.6/bin/singularity build --writable metabolic_b1219a.img Singularity 2>&1  | tee singularity_build.log
		# (see additional comments in the Singularity file)




Debug runs/tests
================

::

        docker run  -it -v $HOME:/home/tin tin6150/metabolic
        docker exec -it uranus_hertz bash                 # additional terminal into existing running container

        testing intermediary container use:
        docker run  -it -v $HOME:/home/tin tin6150/base4metabolic
        docker run  -it -v $HOME:/home/tin tin6150/perl4metabolic

        checking PERL5LIB @INC
        env -i perl -V    # ignores the PERL5LIB env var
        env    perl -V
        both should return the same output, but if root's env got inherited, clear it with something like export PERL5LIB=''

container size
==============

- singularity.sif is  6 GB # Download by Singularity Hub Singularity 3.2 
- singularity.img is 21 GB # 2.6 build on bofh
- docker image ls for metabolic is 16.9 GB (seems to have grown a lot since gtdbtk, but did not include DB).
- docker image ls for perl4metabolic is 1.83 GB.
- 12 GB  is used by /opt/METABOLIC/kofam_database/

above do not include the gtdbtk DB



DB for gtdbtk 
=============

gtdbtk maybe optional.  when running it, may need a DB.  setup as:: 

	GTDBTK_DATA_PATH = /tmp/GTDBTK_DATA
	cd $GTDBTK_DATA_PATH
	wget https://data.ace.uq.edu.au/public/gtdb/data/releases/release89/89.0/gtdbtk_r89_data.tar.gz
	tar xzf gtdbtk_r89_data.tar.gz
	See https://github.com/Ecogenomics/GTDBTk for links to newer db



ATTRIBUTION
===========

* I [tin (at) lbl.gov] only packaged METABOLIC into container to support a user request.
* The source of the METABOLIC software is at https://github.com/AnantharamanLab/METABOLIC



.. # vim: tabstop=4 noexpandtab paste
