-- SUBQUERY(서브쿼리)
-- 사원명이 노옹철인 사람의 부서 조회
SELECT
       DEPT_TITLE
  FROM DEPARTMENT D
  JOIN EMPLOYEE E ON(D.DEPT_ID = E.DEPT_CODE)
 WHERE EMP_NAME = '노옹철'; 
 
-- 부서코드가 노옹철 사원과 같은 소속의 직원명단 조회
SELECT
       E.DEPT_CODE
  FROM EMPLOYEE E
 WHERE E.EMP_NAME = '&이름'; --D9
 
SELECT E.EMP_NAME
  FROM EMPLOYEE E
 WHERE E.DEPT_CODE = 'D9';

SELECT E.EMP_NAME
  FROM EMPLOYEE E
 WHERE E.DEPT_CODE = (SELECT E2.DEPT_CODE
                        FROM EMPLOYEE E2
                       WHERE E2.EMP_NAME = '노옹철'); 


-- 전 직원의 평균급여보다 많은 급여를 받고있는 직원의
-- 사번, 이름, 직급코드, 급여를 조회
SELECT
       E1.EMP_ID
     , E1.EMP_NAME
     , E1.JOB_CODE
     , E1.SALARY
  FROM EMPLOYEE E1
 WHERE E1.SALARY > (SELECT AVG(E2.SALARY)
                      FROM EMPLOYEE E2
                   );
                   
-- 서브쿼리의 유형
-- 단일행 서브쿼리
-- 다중행 서브쿼리
-- 다중열 서브쿼리
-- 다중행 다중열 서브쿼리

-- 서브쿼리 유형에 따라 서브쿼리앞에 붙는 연산자가 다름]
-- 단일행 서브쿼리 앞에는 일반 비교연산자 사용가능
-- >, <, <=, >=, =, !=/<>/^=

-- 노옹철 사원의 급여보다 많은 급여를 받는 직원의
-- 사번, 이름, 부서, 직급, 급여를 조회하세요
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , E.JOB_CODE
     , E.SALARY
  FROM EMPLOYEE E
 WHERE E.SALARY > (SELECT E2.SALARY
                     FROM EMPLOYEE E2
                    WHERE E2.EMP_NAME = '노옹철'
                 ); 

-- 서브쿼리는 SELECT, FROM, WHERE, HAVING, ORDER BY 절에서 사용가능
-- 부서별 급여의 합계 중 가장 큰 부서의 부서명 급여합계를 구하세요
SELECT
       D.DEPT_TITLE
     , SUM(E.SALARY)
  FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
 GROUP BY D.DEPT_TITLE
HAVING SUM(E.SALARY) = (SELECT MAX(SUM(E2.SALARY))
                          FROM EMPLOYEE E2
                         GROUP BY DEPT_CODE
                        ); 


-- 다중행 서브쿼리 : 서브쿼리 결과가 여러행으로 나오는 것
-- 다중행 서브쿼리 앞에는 일반 비교연산자 사용 못함
-- IN / NOT IN 연산자: 여러 개 결과값 중 한 개라도 일치하는 값이 있다면 TRUE/FALSE
-- > ANY, < ANY : 여러 개의 결과값 중 한개라도 큰/작은 경우
--                가장 작은 값보다 크나/가장 큰 값보다 작나?
-- > ALL, < ALL : 모든 값보다 큰/작은 경우
--                가장 큰 값보다 크나? 가장 작은값보다 작나?
-- EXISTS / NOT EXISTS : 모든 값 들 중 해당되는 게 있냐/없냐? 있다면 TRUE/ 없다면 TRUE
-- 부서별 최고급여를 받는 직원의 이름, 직급, 부서, 급여 조회
SELECT
       E.DEPT_CODE
     , MAX(E.SALARY)  
  FROM EMPLOYEE E
 GROUP BY DEPT_CODE; 

SELECT
       E.EMP_NAME
     , E.JOB_CODE
     , E.DEPT_CODE
     , E.SALARY
  FROM EMPLOYEE E
 WHERE E.SALARY IN (SELECT MAX(E2.SALARY)
                      FROM EMPLOYEE E2
                     GROUP BY E2.DEPT_CODE
                    ); 


-- 대리 직급의 직원들 중 과장 직급의 최소급여보다 많이받는 직원의
-- 사번, 이름, 직급명, 급여를 조회
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
  FROM EMPLOYEE E
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE J.JOB_NAME = '과장'; 

SELECT
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
  FROM EMPLOYEE E
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE J.JOB_NAME = '대리'
   AND E.SALARY > ANY (SELECT E2.SALARY
                         FROM EMPLOYEE E2
                         JOIN JOB J2 ON(E2.JOB_CODE = J2.JOB_CODE)
                        WHERE J2.JOB_NAME = '과장'
                       );

-- 차장 직급의 급여의 가장 큰 값보다 많이버는 과장 직급의
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, >ALL  또는 <ALL연산자를 사용
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
  FROM EMPLOYEE E
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE J.JOB_NAME = '과장'
   AND E.SALARY > ALL (SELECT E2.SALARY
                         FROM EMPLOYEE E2
                         JOIN JOB J2 ON(E2.JOB_CODE = J2.JOB_CODE)
                        WHERE J2.JOB_NAME = '차장'
                      );  

SELECT
       E.*
  FROM EMPLOYEE E
 WHERE EXISTS (SELECT E2.*
                 FROM EMPLOYEE E2
                WHERE E2.EMP_ID = '200'
              );  

-- 자기 직급의 평균  급여를 받고있는 직원의
-- 사번, 이름, 직급코드, 급여를 조회하세요
-- 단, 급여와 급여평균은 만원단위로 계산하세요(TRUNC(컬럼명, -5))
SELECT
       E.JOB_CODE
     , TRUNC(AVG(E.SALARY), -5)
  FROM EMPLOYEE E
 GROUP BY E.JOB_CODE; 

SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.JOB_CODE
     , E.SALARY
  FROM EMPLOYEE E
 WHERE TRUNC(E.SALARY, -5) IN (SELECT TRUNC(AVG(E2.SALARY), -5)
                                 FROM EMPLOYEE E2
                                GROUP BY E2.JOB_CODE
                              ); -- 이 경우 다른 직급이라도 지급의 평균급여들과 동일하면 출력되는 문제가 있음

SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.JOB_CODE
     , E.SALARY
  FROM EMPLOYEE E
 WHERE (E.JOB_CODE, E.SALARY) IN (SELECT E2.JOB_CODE
                                       , TRUNC(AVG(E2.SALARY), -5)
                                    FROM EMPLOYEE E2
                                   GROUP BY E2.JOB_CODE
                                 ); -- 여러값을 동시 비교할 때 사용

-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 사원의
-- 이름, 직급, 부서, 입사일 조회
SELECT
       E.EMP_NAME
     , J.JOB_NAME
     , D.DEPT_TITLE
     , E.HIRE_DATE
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE E.ENT_YN = 'N'
   AND (E.DEPT_CODE, E.JOB_CODE) IN (SELECT E2.DEPT_CODE
                                          , E2.JOB_CODE
                                       FROM EMPLOYEE E2
                                      WHERE E2.ENT_YN = 'Y'
                                        AND SUBSTR(E2.EMP_NO, 8, 1) IN ('2', '4', '6')
                                    );  

SELECT
       E.EMP_NAME
     , J.JOB_NAME
     , D.DEPT_TITLE
     , E.HIRE_DATE
  FROM EMPLOYEE E
     , DEPARTMENT D
     , JOB J
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND E.JOB_CODE = J.JOB_CODE
   AND E.ENT_YN = 'N'
   AND (E.DEPT_CODE, E.JOB_CODE) IN (SELECT E2.DEPT_CODE
                                         , E2.JOB_CODE
                                      FROM EMPLOYEE E2
                                     WHERE E2.ENT_YN = 'Y'
                                       AND SUBSTR(E2.EMP_NO, 8,1) IN ('2', '4', '6')
                                   ); 

-- FROM 절에 서브쿼리를 사용할 수 있다.
-- = 인라인 뷰(INLINE VIEW)라고 함
SELECT
       E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
  FROM (SELECT E2.JOB_CODE
             , TRUNC(AVG(E2.SALARY), -5) AS JOBAVG
          FROM EMPLOYEE E2
         GROUP BY E2.JOB_CODE
       ) V
  JOIN EMPLOYEE E ON(V.JOBAVG = E.SALARY AND E.JOB_CODE = V.JOB_CODE)
  JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
 ORDER BY J.JOB_NAME;
 
SELECT
       V.EMP_NAME
     , V.부서명
     , V.직급이름
  FROM (SELECT E.EMP_NAME
             , D.DEPT_TITLE 부서명
             , J.JOB_NAME 직급이름
          FROM EMPLOYEE E
          LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
          JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
       ) V  
 WHERE V.부서명 = '인사관리부';     

-- 인라인 뷰를 활용한 TOP-N 분석
SELECT
       ROWNUM --가상 컬럼(WHERE절에서 실행됨)
     , E.EMP_NAME
     , E.SALARY
  FROM EMPLOYEE E
 ORDER BY E.SALARY;

SELECT ROWNUM
     , V.EMP_NAME
     , SALARY 
  FROM (SELECT E.*
          FROM EMPLOYEE E
         ORDER BY E.SALARY DESC
       ) V
 WHERE ROWNUM <= 5;
-- WHERE ROWNUM BETWEEN 6 AND 10; --ROWNUM은 1부터 차례로 붙고 있는 와중 중간값은 

SELECT
       V2.RNUM
     , V2.EMP_NAME
     , V2.SALARY 
       FROM (SELECT ROWNUM RNUM
                  , V.EMP_NAME
                  , V.SALARY
               FROM (SELECT E.EMP_NAME
                          , E.SALARY
                       FROM EMPLOYEE E
                      ORDER BY E.SALARY DESC
                    )V
            ) V2
 WHERE RNUM BETWEEN 6 AND 10;      

-- STOPKEY 활용
SELECT
       V2.RNUM
     , V2.EMP_NAME
     , V2.SALARY
  FROM (SELECT ROWNUM RNUM
             , V.EMP_NAME
             , V.SALARY
          FROM (SELECT E.EMP_NAME
                     , E.SALARY
                  FROM EMPLOYEE E
                 ORDER BY E.SALARY DESC
               ) V
          WHERE ROWNUM < 11
        ) V2
 WHERE RNUM > 5;       

-- 급여 평균 3위 안에 드는 부서의
-- 부서코드, 부서명, 평균 급여를 조회하세요
SELECT 
       V.DEPT_CODE
     , V.DEPT_TITLE
     , V.AVGSAL
  FROM (SELECT E.DEPT_CODE
             , D.DEPT_TITLE
             , AVG(E.SALARY) AVGSAL
          FROM EMPLOYEE E
          JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
         GROUP BY E.DEPT_CODE, D.DEPT_TITLE
         ORDER BY AVGSAL DESC
       ) V 
 WHERE ROWNUM <= 3;
-- 23 * 9 = 207 
         
SELECT 
       V.DEPT_CODE
     , D.DEPT_TITLE
     , V.AVGSAL
  FROM (SELECT E.DEPT_CODE
             , AVG(E.SALARY) AVGSAL
          FROM EMPLOYEE E          
         GROUP BY E.DEPT_CODE
         ORDER BY AVGSAL DESC
       ) V 
  JOIN DEPARTMENT D ON(V.DEPT_CODE = D.DEPT_ID)     
 WHERE ROWNUM <= 3;
-- 7 * 9 = 63

-- RANK() : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위를 계산하는 방식
-- DENCE_RANK() : 중복되는 순위 이후의 등수를 이후 등수로 처리하는 방식
SELECT
       E.EMP_NAME
     , E.SALARY
     , RANK() OVER(ORDER BY E.SALARY DESC) 순위
  FROM EMPLOYEE E;
  
SELECT
       E.EMP_NAME
     , E.SALARY
     , DENSE_RANK() OVER(ORDER BY E.SALARY DESC) 순위
  FROM EMPLOYEE E;   
  
SELECT
       V.*
  FROM (SELECT E.EMP_NAME
             , E.SALARY
             , RANK() OVER(ORDER BY E.SALARY DESC) 순위
          FROM EMPLOYEE E
       ) V
 WHERE V.순위 BETWEEN 10 AND 19;     

-- 상관(상호연관) 서브쿼리
-- 메인쿼리의 값이 변경되는 거에 따라 서브쿼리에 영향을 미치고
-- 서브쿼리가 만들어진 값을 메인쿼리가 사용하는 상호 연관되어 있는 서브쿼리

-- 관리자 사번이 EMPLOYEE테이블에 있는 직원만조회
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , E.MANAGER_ID
  FROM EMPLOYEE E
 WHERE EXISTS (SELECT E2.EMP_ID
                 FROM EMPLOYEE E2
                WHERE E.MANAGER_ID = E2.EMP_ID
              ); --특징 : 메인쿼리나 서브쿼리 단독으로 실행 불가능  


-- 스칼라 서브쿼리
-- 단일행 서브쿼리 + 상관쿼리

--동일 직급의 평균 급여보다 많이 받고있는 직원
SELECT
       E.EMP_NAME
     , E.JOB_CODE
     , E.SALARY
  FROM EMPLOYEE E
 WHERE E.SALARY > (SELECT TRUNC(AVG(E2.SALARY), -5)
                     FROM EMPLOYEE E2
                    WHERE E.JOB_CODE = E2.JOB_CODE
                  ); 

-- SELECT절에서 스칼라 서브쿼리 이용
-- 모든 사원의 사번, 이름, 관리자 사번, 관리자 명을 조회
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.MANAGER_ID
     , NVL((SELECT E2.EMP_NAME
              FROM EMPLOYEE E2
             WHERE E.MANAGER_ID = E2.EMP_ID
           ), '없음')
  FROM EMPLOYEE E
 ORDER BY 1; 

-- ORDER BY절에서 스칼라 서브쿼리를 이용
-- 모든 직원의 사번, 이름, 소속부서 조회
-- 단, 부서명 내림차순 정렬
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
  FROM EMPLOYEE E
 ORDER BY (SELECT D.DEPT_TITLE
             FROM DEPARTMENT D
            WHERE E.DEPT_CODE = D.DEPT_ID
          ) DESC NULLS LAST;  