pragma solidity ^0.4.11;

contract Venda{
  uint public valor;
  address public vendedor;
  address public comprador;
  enum State {Criado, Travado, Inativo}
  State public state;

  //Criar venda com um determinado valor
  function Venda() payable{
    vendedor = msg.sender
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

  //Eventos
  event Abortar();
  event CompraConfirmada();
  event ItemRecebido();

  //Finalizar uma compra, qualquer um pode chamar essa função
  function confimarCompra() noState(State.Criado) condition(msg.value == valor) payable {
    CompraConfirmada();
    comprador = msg.sender;
    state = State.Travado;
  }

  //Apenas quem comprou o item na função acima pode acessar essa função
  function confimarRecebido() apenasComprador noState(State.Travado) {
    ItemRecebido();
    state = State.Inativo;

    comprador.transfer(valor);
    vendedor.transfer(this.balance);
  }

  //Apenas o vendedor pode acessar a função, para cancelar a venda de algum item
  function abortar() apenasVendedor noState(State.Criado){
    Abortar();
    state = State.Inativo;
    vendedor.transfer(this.balance);
  }
}
