# need to test with docker run --shm-size=1g (ERROR:  could not resize shared memory segment)
# needs at least ___g (>100?) of disk space for all states
cd gisdata

psql -U $POSTGRES_USER -d $POSTGRES_USER -f init_postgis.sql
psql -U $POSTGRES_USER -d $POSTGRES_USER -f app.sql

sh loaders/nation_script_load_docker.sh
sh loaders/state_script_load_PA_docker.sh
sh loaders/state_script_load_NJ_docker.sh

psql -U $POSTGRES_USER -d $POSTGRES_USER -c "SELECT install_missing_indexes();
vacuum analyze tiger.addr;
vacuum analyze tiger.edges;
vacuum analyze tiger.faces;
vacuum analyze tiger.featnames;
vacuum analyze tiger.place;
vacuum analyze tiger.cousub;
vacuum analyze tiger.county;
vacuum analyze tiger.state;
vacuum analyze tiger.zip_lookup_base;
vacuum analyze tiger.zip_state;
vacuum analyze tiger.zip_state_loc;"

sh load_2010_bg.sh

rm -rf temp
rm -rf www2.census.gov
