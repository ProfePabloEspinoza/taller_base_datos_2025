--1 Crear un package llamado HR_INFO que permita mostrar el nombre completo de un empleado y obtener la cantidad total de empleados.
CREATE OR REPLACE PACKAGE hr_info IS
   PROCEDURE show_employee_name(p_emp_id IN NUMBER);
   FUNCTION total_employees RETURN NUMBER;
END hr_info;
/
CREATE OR REPLACE PACKAGE BODY hr_info IS
   PROCEDURE show_employee_name(p_emp_id IN NUMBER) IS
      v_name VARCHAR2(100);
   BEGIN
      SELECT first_name || ' ' || last_name INTO v_name FROM employees WHERE employee_id = p_emp_id;
      DBMS_OUTPUT.PUT_LINE('Empleado: ' || v_name);
   END show_employee_name;

   FUNCTION total_employees RETURN NUMBER IS
      v_total NUMBER;
   BEGIN
      SELECT COUNT(*) INTO v_total FROM employees;
      RETURN v_total;
   END total_employees;

   END hr_info; /

BEGIN
   hr_info.show_employee_name(100);
   DBMS_OUTPUT.PUT_LINE('Total de empleados: ' || hr_info.total_employees);
END;
/


--2 Crear un package llamado DEPT_OPERATIONS que contenga un procedimiento para mostrar información de un departamento y una función para obtener el promedio de salario del mismo.

CREATE OR REPLACE PACKAGE dept_operations IS
   PROCEDURE show_department_info(p_dept_id IN NUMBER);
   FUNCTION avg_salary(p_dept_id IN NUMBER) RETURN NUMBER;
END dept_operations;
/


CREATE OR REPLACE PACKAGE BODY dept_operations IS
   PROCEDURE show_department_info(p_dept_id IN NUMBER) IS
      v_name VARCHAR2(50);
      v_location VARCHAR2(50);
   BEGIN
      SELECT department_name, location_id INTO v_name, v_location
      FROM departments
      WHERE department_id = p_dept_id;

      DBMS_OUTPUT.PUT_LINE('Departamento: ' || v_name || ' | Ubicación: ' || v_location);
   END show_department_info;

   FUNCTION avg_salary(p_dept_id IN NUMBER) RETURN NUMBER IS
      v_avg NUMBER;
   BEGIN
      SELECT AVG(salary) INTO v_avg FROM employees WHERE department_id = p_dept_id;
      RETURN v_avg;
   END avg_salary;
END dept_operations;
/


BEGIN
   dept_operations.show_department_info(90);
   DBMS_OUTPUT.PUT_LINE('Promedio de salario: ' || dept_operations.avg_salary(90));
END;
/



--3 Crear un package llamado EMP_STATS que calcule el promedio de salario mediante una función privada y muestre los resultados con un procedimiento público.

CREATE OR REPLACE PACKAGE emp_stats IS
   PROCEDURE show_salary_info(p_dept_id IN NUMBER);
END emp_stats;
/


CREATE OR REPLACE PACKAGE BODY emp_stats IS
   -- Función privada
   FUNCTION calculate_avg_salary(p_dept_id IN NUMBER) RETURN NUMBER IS
      v_avg NUMBER;
   BEGIN
      SELECT AVG(salary) INTO v_avg FROM employees WHERE department_id = p_dept_id;
      RETURN v_avg;
   END calculate_avg_salary;

   -- Procedimiento público
   PROCEDURE show_salary_info(p_dept_id IN NUMBER) IS
      v_avg NUMBER;
   BEGIN
      v_avg := calculate_avg_salary(p_dept_id);
      DBMS_OUTPUT.PUT_LINE('Departamento ' || p_dept_id || ' - Promedio de salario: ' || v_avg);
   END show_salary_info;
END emp_stats;
/


BEGIN
   emp_stats.show_salary_info(60);
END;
/


