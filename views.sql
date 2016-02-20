-- VIEWS!

use `Jonas Discos`;

CREATE VIEW lucros_ate_agora AS
SELECT Loja.id, total_fact - total_gasto FROM Loja;

SELECT * FROM lucros_ate_agora;