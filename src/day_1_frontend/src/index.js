import { day_1_backend } from "../../declarations/day_1_backend";

// document.querySelector("form").addEventListener("submit", async (e) => {
//   e.preventDefault();
//   const button = e.target.querySelector("button");

//   const name = document.getElementById("name").value.toString();

//   button.setAttribute("disabled", true);

//   // Interact with foo actor, calling the greet method
//   const greeting = await day_1_backend.greet(name);

//   button.removeAttribute("disabled");

//   document.getElementById("greeting").innerText = greeting;

//   return false;
// });

const buttonsContainer = document.getElementById('buttons-container');
const operaciones = [{ 'add': day_1_backend.add }, { 'sub': day_1_backend.sub }, { 'mul': day_1_backend.mul }, { 'div': day_1_backend.div }, { '^': day_1_backend.power }, { '√': day_1_backend.sqrt }];
const numeros = [7, 8, 9, 4, 5, 6, 1, 2, 3, 0];

const input = document.getElementById('pre-result');
const resultado = document.getElementById('result');

const botonesEspeciales = [
  { etiqueta: '=', accion: calcularResultado },
  { etiqueta: 'C', accion: borrarTodo }
];

window.addEventListener("DOMContentLoaded", async function () {
  try {
    resultado.value = await day_1_backend.see();
  } catch (error) {
    console.log(error);
  }
})



function crearBoton(texto, onClick) {
  const boton = document.createElement('button');
  if (typeof texto == 'object') boton.textContent = Object.keys(texto)[0]
  else boton.textContent = texto;
  boton.addEventListener('click', onClick);
  buttonsContainer.appendChild(boton);
}

async function agregarAlResultado(valor) {
  if (input.value === '0') {
    input.value = valor;
  } else {
    input.value += valor;
  }
  // console.log(input.value);

}

async function agregarOperador(operador) {

  const operacion = operaciones.find(op => Object.keys(op)[0] == Object.keys(operador)[0])
  console.log(operacion)
  console.log(day_1_backend.sqrt)

  if (operacion['√']) await operacion[Object.keys(operador)[0]]();
  else await operacion[Object.keys(operador)[0]](parseFloat(input.value));

  resultado.value = await day_1_backend.see()
  input.value = 0
}

async function calcularResultado() {
  const expresion = input.value;
  let total;

  try {

    total = await day_1_backend.see()
    console.log(total)
    // eval(expresion);

  } catch (error) {
    total = 'Error';
  }

  resultado.value = total;
  input.value = 0;
}


async function borrarTodo() {
  try {
    await day_1_backend.reset();
    resultado.value = 0
    input.value = 0
    // console.log(input.value);

    // resultado.value = '0';
  } catch (error) {

  }
}

// Generar botones para las operaciones
operaciones.forEach(operacion => {
  crearBoton(operacion, () => agregarOperador(operacion));
});

// Generar botones para los números
numeros.forEach(numero => {
  crearBoton(numero, () => agregarAlResultado(numero));
});

// Generar botones especiales
botonesEspeciales.forEach(boton => {
  crearBoton(boton.etiqueta, boton.accion);
});
