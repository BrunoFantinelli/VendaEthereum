pragma solidity ^0.4.11;

contract Venda{
    uint256 public valor;
    address public vendedor;
    address public comprador;
    enum State {Criado, Travado, Inativo}
    State public state;

    //Criar venda com um determinado valor
    function Venda() payable{
        vendedor = msg.sender;
        valor = msg.value;
    }

    //Modificadores para controlar acesso nas funções
    modifier condition(bool _condition){
        require(_condition);
        _;
    }

    modifier apenasComprador(){
        //Requer que quem chamou o contrato seja o comprador
        require(msg.sender == comprador);
        _;
    }

    modifier apenasVendedor(){
        //Requer que quem chamou o contrato seja o vendedor
        require(msg.sender == vendedor);
        _;
    }

    modifier noState(State _state){
        require(state == _state);
        _;
    }
  
    modifier valorAcima(){
        require(msg.value >= valor);
        _;
    }

    //Eventos
    event Abortar();
    event CompraConfirmada();
    event ItemRecebido();
    event TrocoEnviado(address comprador, uint troco);

    //Finalizar uma compra, qualquer um pode chamar essa função
    function confimarCompra() noState(State.Criado) valorAcima() payable{
        comprador = msg.sender;
    
        //Calcula o troco e envia para o comprador
        if(msg.value > valor){
            uint256 troco = msg.value - valor;
            comprador.transfer(troco);
            TrocoEnviado(comprador, troco);
        }
    
        CompraConfirmada();

        state = State.Travado;
    }

    //Apenas quem comprou o item na função acima pode acessar essa função
    function confimarRecebido() apenasComprador noState(State.Travado) {
        ItemRecebido();
        state = State.Inativo;

        vendedor.transfer(valor);
        vendedor.transfer(this.balance);
    }

    //Apenas o vendedor pode acessar a função, para cancelar a venda de algum item
    function abortar() apenasVendedor noState(State.Criado){
        Abortar();
        state = State.Inativo;
        vendedor.transfer(this.balance);
    }
}