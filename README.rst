Metabolic
---------

This project 
( https://github.com/tin6150/metabolic.git )
is the containerization of AnantharamanLab/METABOLIC
( https://github.com/AnantharamanLab/METABOLIC ).

Starting the Metabolic container
================================

::

	singularity pull --name metabolic.sif shub://tin6150/metabolic
	./metabolic.sif
	-or-
	sudo docker run  -it -v $HOME:/home tin6150/metabolic

The above commands will drop you into a shell inside the container, 
where the metabolic program and all its dependencies are installed.
Host system need to have Singularity 3.2 installed.

The metabolic software is installed under /opt/METABOLIC
5_genomes_test has been extracted under this directory as well.
/usr/bin/xpdf could be used to view the generated PDF.


REMEMBER: content stored INSIDE the container is ephemeral and lost when container is restarted.  Save your data to a mounted volume shared with the host, eg $HOME


Example Run:  METABOLIC-G.pl
============================

::

	cd $HOME    # if using lawrencium, please use luster scratch dir instead.
	tar xfz /opt/METABOLIC/5_genomes_test.tgz
	perl /opt/METABOLIC/METABOLIC-G.pl -in-gn $HOME/5_genomes_test/Genome_files -t 34 -o $HOME/metabolic_out -m /opt/METABOLIC/

	# options are:
	# -in-gn [folder with all your genomes] 
	# -t [number of threads]   # even at 34 threads on 36-core machine, load average seems to remain below 8.
	# -o [METABOLIC output folder] 
	# -m your/path/to/put/METABOLIC-folder


Info about the Metabolic container
==================================

A docker container is build first, done as 3 cascading parts:

1. Dockerfile.base: Debian Linux with R 3.6.2 (and CRAN libs) and number of .deb packages to satisfy dependencies (Hmmer, etc)

2. Dockerfile.perl: add BioPerl and other CPAN libraries

3. Dockerfile.metabolic: add miniconda, sambamba, and METABOLIC.
    - run_setup.sh has been run, software is installed under /opt/METABOLIC .
    - 5_genomes_test has been extracted under this directory as well, but dir by default is not writable.


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
        -or-
        docker build -t tin6150/metabolic0      -f Dockerfile            .  | tee Dockerfile.monolithic.log 
        -or-
        # alternate starting point, may become independent container if can get docker hub to add new repo...
        docker build -t tin6150/bioperl         -f Dockerfile.bioperl    .  | tee Dockerfile.bioperl.log 

        THEN
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


