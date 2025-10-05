--1
-- Función: calcula el sueldo anual
CREATE OR REPLACE FUNCTION get_annual_salary(p_emp_id IN employees.employee_id%TYPE)
RETURN NUMBER IS
    v_salary employees.salary%TYPE;
BEGIN
    SELECT salary INTO v_salary
    FROM employees
    WHERE employee_id = p_emp_id;

    RETURN v_salary * 12;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

-- Procedimiento: muestra nombre y sueldo anual
CREATE OR REPLACE PROCEDURE show_annual_salary(p_emp_id IN employees.employee_id%TYPE) IS
    v_full_name VARCHAR2(100);
    v_annual NUMBER;
BEGIN
    v_annual := get_annual_salary(p_emp_id);

    SELECT first_name || ' ' || last_name
    INTO v_full_name
    FROM employees
    WHERE employee_id = p_emp_id;

    DBMS_OUTPUT.PUT_LINE('Empleado: ' || v_full_name);
    DBMS_OUTPUT.PUT_LINE('Sueldo Anual: ' || NVL(v_annual,0));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe empleado con ID ' || p_emp_id);
END;
/

-- Ejemplo de ejecución
BEGIN
    show_annual_salary(100);
END;
/





--2 
-- Función: retorna sueldo promedio de un departamento
CREATE OR REPLACE FUNCTION avg_salary_dept(p_dept_id IN departments.department_id%TYPE)
RETURN NUMBER IS
    v_avg NUMBER;
BEGIN
    SELECT AVG(salary)
    INTO v_avg
    FROM employees
    WHERE department_id = p_dept_id;

    RETURN v_avg;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

-- Procedimiento: muestra el nombre del departamento y su sueldo promedio
CREATE OR REPLACE PROCEDURE show_avg_salary_dept(p_dept_id IN departments.department_id%TYPE) IS
    v_dept_name departments.department_name%TYPE;
    v_avg NUMBER;
BEGIN
    -- Obtener nombre de departamento
    SELECT department_name
    INTO v_dept_name
    FROM departments
    WHERE department_id = p_dept_id;

    -- Llamar a la función
    v_avg := avg_salary_dept(p_dept_id);

    IF v_avg IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('El departamento ' || v_dept_name || ' no tiene empleados.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Departamento: ' || v_dept_name);
        DBMS_OUTPUT.PUT_LINE('Sueldo Promedio: ' || ROUND(v_avg, 2));
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe departamento con ID ' || p_dept_id);
END;
/

-- Ejemplo de ejecución
BEGIN
    show_avg_salary_dept(60); -- Ejecuta con un departamento existente
END;
/
