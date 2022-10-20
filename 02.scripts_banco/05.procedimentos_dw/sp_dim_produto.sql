USE bd_rede_postos

CREATE OR ALTER PROCEDURE SP_DIM_PRODUTO (@DATA_CARGA DATETIME) AS
BEGIN
	DECLARE @COD_PRODUTO INT, @PRODUTO VARCHAR(100), @COD_SUBCATEGORIA INT,
	@SUBCATEGORIA VARCHAR(100), @COD_CATEGORIA INT, @CATEGORIA VARCHAR(100)

	DECLARE C_PRODUTO CURSOR FOR SELECT COD_PRODUTO, 
	PRODUTO, COD_SUBCATEGORIA, SUBCATEGORIA, COD_CATEGORIA, CATEGORIA FROM TB_AUX_PRODUTO 
	WHERE DATA_CARGA = @DATA_CARGA
	
	OPEN C_PRODUTO
	FETCH C_PRODUTO INTO @COD_PRODUTO, @PRODUTO, @COD_SUBCATEGORIA, @SUBCATEGORIA, @COD_CATEGORIA, @CATEGORIA
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		-- UPDATE
		IF EXISTS (SELECT COD_PRODUTO FROM DIM_PRODUTO WHERE COD_PRODUTO = @COD_PRODUTO)
		BEGIN
			UPDATE DIM_PRODUTO SET COD_PRODUTO = @COD_PRODUTO, PRODUTO = @PRODUTO,
			COD_CATEGORIA = @COD_CATEGORIA, CATEGORIA = @CATEGORIA
			WHERE COD_PRODUTO = @COD_PRODUTO
		END
		-- INSERT
		ELSE
		BEGIN
			INSERT INTO DIM_PRODUTO VALUES(@COD_PRODUTO, @PRODUTO, @COD_CATEGORIA, @SUBCATEGORIA, @COD_CATEGORIA, @CATEGORIA)
		END
		FETCH C_PRODUTO INTO @COD_PRODUTO, @PRODUTO, @COD_SUBCATEGORIA, @SUBCATEGORIA, @COD_CATEGORIA, @CATEGORIA
	END
	CLOSE C_PRODUTO
	DEALLOCATE C_PRODUTO
END