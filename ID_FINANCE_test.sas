***********************************************************;
* THE MACRO IS TO RESPOND AT SQL TASK FOR IDFINANCE       *;
* AUTH: MARIUS BIRSAN, 11jul2023                          *;
* ------------------------------------------------------- *;
*REQ:
/*	

a) Select a list of employees with the salary greater than their line manager’s (chief’s) 
b) Select a list of employees with max salary within their department 
c) Select a list of all departments with no more than 3 employees each 
d) Select a list of employees who do not have a manager working in the same department 
e) Select the departments with max salary (sum of salaries of all employees)

*/

* ------------------------------------------------------- *;
* CONTACT:                                                *;
*  marius.birsan86@gmail.com                              *;
***********************************************************;

data DEPARTAMNET;
	infile datalines delimiter='#';
	input ID 4. NAME $;
	datalines;
1000#ABC
1001#ABD
1002#ABE
1003#ABF
1004#ABG
1005#ABH
1006#ABI
1007#ABJ
1008#ABK
1009#ABL
1010#ABM
1011#ABM1
1012#ABM2
;

data EMPLOYEE;
	infile datalines delimiter='#';
	input ID DEPARTMENT_ID CHIEF_ID NAME $ SALARY;
	datalines;
	1000#10#1000#ABC#9090
	1001#20#1001#ABD#9999
	1002#30#1002#ABE#5000
	1003#10#1000#ABF#400
	1004#10#1000#ABG#500
	1005#20#1001#ABH#1000
	1006#20#1001#ABI#2000
	1007#20#1001#ABJ#200000
	1008#30#1002#ABK#800
	1009#30#1002#ABL#600
	1010#30#1002#ABM#555000
	1011#10#1001#ABM1#100
	1012#10#1001#ABM2#100
	;

	/* 	a) Select a list of employees with the salary greater than their line manager’s (chief’s)  */
PROC SQL;
	SELECT DISTINCT K1.ID FROM WORK.EMPLOYEE K1 INNER JOIN (SELECT DISTINCT 
		MAX(T1.SALARY) AS MAX_SALARY, T1.DEPARTMENT_ID FROM WORK.EMPLOYEE T1 GROUP BY 
		T1.DEPARTMENT_ID)K2 ON K1.SALARY=K2.MAX_SALARY AND 
		K1.DEPARTMENT_ID=K2.DEPARTMENT_ID WHERE K1.ID<>K1.CHIEF_ID;
QUIT;

/* b) Select a list of employees with max salary within their department  */
PROC SQL;
	SELECT DISTINCT K1.ID FROM WORK.EMPLOYEE K1 INNER JOIN (SELECT DISTINCT 
		MAX(T1.SALARY) AS MAX_SALARY, T1.DEPARTMENT_ID FROM WORK.EMPLOYEE T1 GROUP BY 
		T1.DEPARTMENT_ID)K2 ON K1.SALARY=K2.MAX_SALARY AND 
		K1.DEPARTMENT_ID=K2.DEPARTMENT_ID;
QUIT;

/* c) Select a list of all departments with no more than 3 employees each  */


%let param_nb_emp=3;

/*we  could put in this parameter whatever number is requested*/
PROC SQL;
	SELECT DISTINCT K1.DEPARTMENT_ID FROM WORK.EMPLOYEE K1 GROUP BY 
		K1.DEPARTMENT_ID HAVING COUNT(K1.ID)>&param_nb_emp.;
QUIT;

/* d) Select a list of employees who do not have a manager working in the same department  */
PROC SQL;
	CREATE TABLE EMP_DIFF_MNG AS SELECT DISTINCT T1.ID FROM WORK.EMPLOYEE T1 LEFT 
		JOIN (SELECT DISTINCT K1.DEPARTMENT_ID, K1.CHIEF_ID FROM WORK.EMPLOYEE K1 
		WHERE K1.ID=K1.CHIEF_ID) T2 ON T1.DEPARTMENT_ID=T2.DEPARTMENT_ID AND 
		T1.CHIEF_ID=T2.CHIEF_ID WHERE T2.DEPARTMENT_ID IS MISSING;
QUIT;

/* e) Select the departments with max salary (sum of salaries of all employees) */
PROC SQL;
	SELECT K1.DEPARTMENT_ID FROM(SELECT SUM(K2.SALARY) AS SUM_SAL, 
		K2.DEPARTMENT_ID FROM WORK.EMPLOYEE K2 GROUP BY K2.DEPARTMENT_ID)K1 WHERE 
		K1.SUM_SAL=(SELECT MAX (K3.SUM_SAL_) FROM (SELECT SUM(K4.SALARY)AS SUM_SAL_, 
		K4.DEPARTMENT_ID FROM WORK.EMPLOYEE K4 GROUP BY K4.DEPARTMENT_ID)K3);
QUIT;