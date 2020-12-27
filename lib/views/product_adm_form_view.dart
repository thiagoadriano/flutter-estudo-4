import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/services/request_products.dart';

class ProductsAdmFormView extends StatefulWidget {
  @override
  _ProductsAdmFormViewState createState() => _ProductsAdmFormViewState();
}

class _ProductsAdmFormViewState extends State<ProductsAdmFormView> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(_updateThumbnailImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final product = ModalRoute.of(context).settings.arguments as Product;

    if (_formData.isEmpty && product != null) {
      _formData['id'] = product.id;
      _formData['title'] = product.title;
      _formData['description'] = product.description;
      _formData['price'] = product.price;
      _formData['imageUrl'] = product.imageUrl;

      _imageUrlController.text = product.imageUrl;
    } else {
      _formData['title'] = '';
      _formData['description'] = '';
      _formData['price'] = '';
      _formData['imageUrl'] = '';
    }
  }

  void _updateThumbnailImage() {
    if (isValidUrlImage(_imageUrlController.text.trim())) {
      setState(() {});
    }
  }

  bool isValidUrlImage(String url) {
    final reg = RegExp(r'\.(jpe?g|png)$');
    bool isValidProtocol = url.toLowerCase().startsWith(RegExp(r'https?'));
    bool isValidExtension = reg.hasMatch(url.toLowerCase());
    return isValidProtocol && isValidExtension;
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageFocusNode.removeListener(_updateThumbnailImage);
    _imageFocusNode.dispose();
  }

  void _saveForm() async {
    bool isValid =  _form.currentState.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();
   
    final newProduct = Product(
      id: _formData['id'],
      title: _formData['title'],
      price: _formData['price'],
      description: _formData['description'],
      imageUrl: _formData['imageUrl'],
    );

    final prodProvider = Provider.of<ProductsProvider>(context, listen: false);

    if(_formData['id'] == null) {
      prodProvider.addItem(newProduct);      
    } else {
      prodProvider.updateItem(newProduct);
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario produto'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['title'],
                decoration: InputDecoration(labelText: 'Titulo'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _formData['title'] = value;
                },
                validator: (value) {
                  bool isEmpty = value.trim().isEmpty;
                  bool isInvalid = value.trim().length < 3;
                  
                  if (isEmpty || isInvalid) {
                    return 'Informe um titulo valido com no minimo 3 letras!';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['price'].toString(),
                decoration: InputDecoration(labelText: 'Preco'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descFocusNode);
                },
                onSaved: (value) {
                  _formData['price'] = double.parse(value);
                },
                validator: (value) {
                  bool isEmpty = value.trim().isEmpty;
                  var testValue = double.tryParse(value.trim());
                  bool isInvalid = testValue == null || testValue < 0;
                  
                  if (isEmpty || isInvalid) {
                    return 'Informe um preco valido!';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['description'],
                decoration: InputDecoration(labelText: 'Descricao'),
                maxLines: 3,
                focusNode: _descFocusNode,
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  _formData['description'] = value;
                },
                validator: (value) {
                  bool isEmpty = value.trim().isEmpty;
                  bool isInvalid = value.trim().length < 10;
                  
                  if (isEmpty || isInvalid) {
                    return 'Informe uma descricao valida com no minimo 10 letras!';
                  }

                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Url da Imagem'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageFocusNode,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _formData['imageUrl'] = value;
                      },
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = !isValidUrlImage(value);
                        
                        if (isEmpty || isInvalid) {
                          return 'Informe uma URL valida!';
                        }

                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(top: 10, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Informe a URL')
                          : Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
