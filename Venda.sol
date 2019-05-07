pragma solidity ^0.4.11;

contract Venda{
  uint public valor;
  address public vendedor;
  address public comprador;
  enum State {Criado, Travado, Inativo}
  State public state;

  function Venda() payable{
    vendedor = msg.sender
    valor = msg.value;
  }

  modifier condition(bool _condition){
    require(_condition);
    _;
  }

  modifier apenasComprador(){
    require(msg.sender == comprador);
    _;
  }

  modifier apenasVendedor(){
    require(msg.sender == vendedor);
    _;
  }

  modifier noState(State _state){
    require(state == _state);
    _;
  }

  event Abortar();
  event CompraConfirmada();
  event ItemRecebido();

  function confimarCompra() noState(State.Criado) condition(msg.value == valor) payable {
    CompraConfirmada();
    comprador = msg.sender;
    state = State.Travado;
  }

  function confimarRecebido() apenasComprador noState(State.Travado) {
    ItemRecebido();
    state = State.Inativo;

    comprador.transfer(valor);
    vendedor.transfer(this.balance);
  }

  function abortar() apenasVendedor noState(State.Criado){
    Abortar();
    state = State.Inativo;
    vendedor.transfer(this.balance);
  }
}
