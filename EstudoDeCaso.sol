pragma solidity ^0.4.11;

contract EstudoDeCaso {
    address comprador;
    address vendedor;
    address banco;
    address transportadora;

    uint256 valor_venda;
    uint256 valor_transportadora;

    bool pagamentoRealizado;
    bool produtoRecebido;
    bool produtoEnviado;
    bool transporPaga;
    bool fretePago;

    event notificarVendedor(address comprador, address banco);
    event notificarBanco(address comprador, bool produtoRecebido);
    event transportadoraPaga(address banco, bool transporPaga);
    event produtoComprado(address comprador, address seller, uint256 valorVenda);
    event produtoEnviadoParaComprador(address comprador, address transportadora);
    event produtoEntregueParaComprador(address transportadora, address comprador, bool produtoRecebido);

    modifier apenasComprador() {
        require(msg.sender == comprador);
        _;
    }

    modifier apenasVendedor() {
        require(msg.sender == vendedor);
        _;
    }

    modifier apenasBanco(){
        require(msg.sender == banco);
        _;
    }

    modifier apenasTransportadora(){
        require(msg.sender == transportadora);
        _;
    }

    function EstudoDeCaso (address _comprador, address _vendedor, address _banco, address _transportadora, uint256 _valor_venda, uint256 _valor_transportadora) public {
        comprador = _comprador;
        vendedor = _vendedor;
        banco = _banco;
        transportadora = _transportadora;
        valor_venda = _valor_venda;
        valor_transportadora = _valor_transportadora;
        pagamentoRealizado = false;
        produtoRecebido = false;
        produtoEnviado = false;
        transporPaga = false;
        fretePago = false;
    }

    //Funções Comprador
    function comprarProduto() apenasComprador(){
        produtoComprado(comprador, vendedor, valor_venda);
        pagarProdutoParaBanco();
    }

    function pagarProdutoParaBanco() apenasComprador() {
        banco.transfer(valor_venda);
        pagamentoRealizado = true;
    }

    function notificarProdutoRecebido() apenasComprador(){
        produtoRecebido = true;
        notificarBanco(comprador, produtoRecebido);
    }

    //Funções Banco
    function notificarProdutoPago() apenasBanco(){
        notificarVendedor(comprador, banco);
    }


    function pagarProdutoParaVendedor() apenasBanco(){
        if(pagamentoRealizado == true){
            vendedor.transfer(valor_venda);
        }
    }

    function pagarTransportadora() apenasBanco(){
        if(fretePago == true){
          transportadora.transfer(valor_transportadora);
          transporPaga = true;
        }
    }

    //Funções vendedor
    function enviarProduto() apenasVendedor(){
        produtoEnviadoParaComprador(vendedor, transportadora);
        produtoEnviado = true;
    }

    function pagarFrete() apenasVendedor(){
        banco.transfer(valor_transportadora);
        fretePago = true;
    }

    //Funções transportadora
    function notificarProdutoEntregue() apenasTransportadora(){
        produtoEntregueParaComprador(transportadora, comprador, produtoRecebido);
    }

}
