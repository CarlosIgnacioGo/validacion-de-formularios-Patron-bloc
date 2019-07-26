import 'dart:io';
import 'package:rxdart/rxdart.dart';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/provider/productos_provider.dart';

class ProductosBloc {
  final _productosController = new BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productosProvider = new ProductosProvider();

  Stream<List<ProductoModel>> get productosStream => _productosController.stream;
  Stream<bool>                get cargandoStream  => _cargandoController.stream;

  void cargarProductos() async {
    final productos = await _productosProvider.cargarProductos();

    _productosController.sink.add(productos);
  }

  void agregarProducto(ProductoModel producto) async {
    _cargandoController.sink.add(true);
    await _productosProvider.crearProducto(producto);
    _cargandoController.sink.add(false);
  }

  void editarProducto(ProductoModel producto) async {
    _cargandoController.sink.add(true);
    await _productosProvider.editarProducto(producto);
    _cargandoController.sink.add(false);
  }

  void borrarProducto(String id) async {
    await _productosProvider.borrarProductos(id);
  }

  Future<String> subirFoto(File file) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _productosProvider.subirImagen(file);
    _cargandoController.sink.add(false);

    return fotoUrl;
  }

  dispose(){
    _productosController?.close();
    _cargandoController?.close();
  }




}