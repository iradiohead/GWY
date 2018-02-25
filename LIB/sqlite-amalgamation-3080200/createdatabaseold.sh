echo "create table testpaperup(tid integer primary key,time integer,location text,type text,status text,name text);" | sqlite3 database1.db
echo ".import testpaperup.csv testpaperup" | sqlite3 database1.db
echo "create table material(mid integer primary key,meterial_t text,meterial_p text);" | sqlite3 database1.db 
echo ".import material.csv material" | sqlite3 database1.db
echo "create table problemup(pid integer primary key,pidintest integer,tid integer references testpaperup(tid),problem_t text,choice_a_t text,choice_b_t text,choice_c_t text,choice_d_t text,answer text,analyse_t text,problem_p text,choice_a_p text,choice_b_p text,choice_c_p text,choice_d_p text,analyse_p text,type text,status text,mid integer references material(mid),choice_type text);" | sqlite3 database1.db
echo ".import problemup.csv problemup" | sqlite3 database1.db
