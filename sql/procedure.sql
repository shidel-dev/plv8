-- create a table to hold the data
CREATE TABLE test1 (a INTEGER);

-- and create a procedure that uses rollback and commit
-- note this will fail on versions older than 11
CREATE PROCEDURE transaction_test1()
LANGUAGE plv8
AS $$
for (let i = 0; i < 10; i++) {
  plv8.execute('INSERT INTO test1 (a) VALUES ($1)', [i]);
  if (i % 2 == 0)
    plv8.commit();
  else
    plv8.rollback();
}
$$;

call transaction_test1();

-- and get the results back
SELECT a FROM test1;

-- cleanup
DROP TABLE test1;
DROP PROCEDURE transaction_test1;
