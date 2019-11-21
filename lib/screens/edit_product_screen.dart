import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/product.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit_product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

//https://static.kiabi.com/images/pantalon-de-costume-slim-en-twill-bleu-marine-homme-te006_2_fcf1.jpg

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValue = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((_imageUrlController.text.startsWith('http') &&
          _imageUrlController.text.startsWith('https'))) return;
    }
    setState(() {});
  }

  void _saveForm() {
    var _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_editProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editProduct)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.purple,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValue['title'],
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                          title: value,
                          description: _editProduct.description,
                          price: _editProduct.price,
                          imageUrl: _editProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['price'],
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid numer';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                          title: _editProduct.title,
                          description: _editProduct.description,
                          price: double.parse(value),
                          imageUrl: _editProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['description'],
                      textInputAction: TextInputAction.next,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter a description.';
                        }

                        if (value.length < 10) {
                          return 'Should be at least 10 character.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                          title: _editProduct.title,
                          description: value,
                          price: _editProduct.price,
                          imageUrl: _editProduct.imageUrl,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(right: 8, top: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: Center(
                            child: _imageUrlController.text.isEmpty
                                ? Text('Preview')
                                : FittedBox(
                                    fit: BoxFit.cover,
                                    child: Image.network(
                                      _imageUrlController.text,
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            focusNode: _imageUrlFocusNode,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            decoration: InputDecoration(
                              labelText: 'Image Url',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter an image Url.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Enter a valide Url.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editProduct = Product(
                                id: _editProduct.id,
                                isFavorite: _editProduct.isFavorite,
                                title: _editProduct.title,
                                description: _editProduct.description,
                                price: _editProduct.price,
                                imageUrl: value,
                              );
                            },
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
