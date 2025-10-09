
--Ejemplo 1 – Trigger a Nivel de Sentencia (Auditoría General)

--Objetivo: Registrar cualquier operación (INSERT, UPDATE o DELETE) en la tabla EMPLOYEES dentro de una 
--tabla de auditoría.
-- 1. Crear tabla de auditoría
CREATE TABLE employees_audit (
    audit_id NUMBER PRIMARY KEY,
    operation VARCHAR2(10),
    change_date DATE
);

-- 2. Crear secuencia para generar IDs
CREATE SEQUENCE emp_audit_seq START WITH 1 INCREMENT BY 1;

-- 3. Crear trigger a nivel de sentencia
CREATE OR REPLACE TRIGGER employees_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON employees
BEGIN
    IF INSERTING THEN
        INSERT INTO employees_audit VALUES (emp_audit_seq.NEXTVAL, 'INSERT', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO employees_audit VALUES (emp_audit_seq.NEXTVAL, 'UPDATE', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO employees_audit VALUES (emp_audit_seq.NEXTVAL, 'DELETE', SYSDATE);
    END IF;
END;
/

-- prueba:

UPDATE employees SET salary = salary * 1.05 WHERE department_id = 90;

SELECT * FROM employees_audit;


----Ejemplo 2 – Trigger a Nivel de Fila (Auditoría Detallada)

--Objetivo: Registrar cada cambio de salario de un empleado, mostrando el antiguo y el nuevo salario.

-- 1. Crear tabla de auditoría
CREATE TABLE emp_salary_audit (
    audit_id NUMBER PRIMARY KEY,
    employee_id NUMBER,
    old_salary NUMBER,
    new_salary NUMBER,
    change_date DATE
);

-- 2. Crear secuencia
CREATE SEQUENCE emp_salary_audit_seq START WITH 1 INCREMENT BY 1;

-- 3. Crear trigger a nivel de fila
CREATE OR REPLACE TRIGGER audit_salary_changes
AFTER UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
    INSERT INTO emp_salary_audit
    VALUES (emp_salary_audit_seq.NEXTVAL, :OLD.employee_id, :OLD.salary, :NEW.salary, SYSDATE);
END;
/

--prueba:

UPDATE employees SET salary = salary + 100 WHERE department_id = 60;

SELECT * FROM emp_salary_audit;



--💬 Ejemplo 3 – Validación con Trigger BEFORE

--Objetivo: Evitar que se inserten empleados con salario menor a 1000.

CREATE OR REPLACE TRIGGER validate_salary
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
    IF :NEW.salary < 1000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El salario no puede ser menor a 1000');
    END IF;
END;
/

INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, job_id, salary)
VALUES (999, 'Test', 'LowSalary', 'test999@hr.com', SYSDATE, 'IT_PROG', 500);
