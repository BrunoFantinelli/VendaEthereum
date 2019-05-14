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
    event produtoEnviado(address comprador. address transportadora);
    event produtoEntregue(address transportadora, address comprador, bool produtoRecebido);

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

    constructor(address _comprador, address _vendedor, address _banco, address _transportadora, uint256 _valor_venda, uint256 _valor_transportadora) {
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
        pagarProduto();
    }

    function pagarProduto() apenasComprador() {
        banco.send(valor_venda);
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


    function pagarProduto() apenasBanco(){
        if(pagamentoRealizado == true){
            vendedor.send(valor_venda);
        }
    }

    function pagarTransportadora() apenasBanco(){
        if(fretePago = true){
          transportadora.send(valor_transportadora);
          transporPaga = true;
        }
    }

    //Funções vendedor
    function enviarProduto() apenasVendedor(){
        produtoEnviado(vendedor, transportadora);
        produtoEnviado = true;
    }

    function pagarFrete() apenasVendedor(){
        banco.send(valor_transportadora);
        fretePago = true;
    }

    //Funções transportadora
    function notificarProdutoEntregue() apenasTransportadora(){
        notificarProdutoEntregue(transportadora, comprador, produtoRecebido);
    }

}
