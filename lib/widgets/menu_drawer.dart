import 'dart:io';

import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/provider/product_list_provider.dart';
import 'package:app_tienda_comida/screens/account_relateds/redirect_screen.dart';
import 'package:app_tienda_comida/screens/business_management.dart';
import 'package:app_tienda_comida/screens/home_screen.dart';
import 'package:app_tienda_comida/screens/orders_related/orders_screen.dart';
import 'package:app_tienda_comida/utils/account_validation.dart';
import 'package:app_tienda_comida/utils/image_compressor.dart';
import 'package:app_tienda_comida/widgets/custom_future_builder.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:app_tienda_comida/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../screens/settings_screen.dart';

class MenuDrawer extends StatelessWidget {
  final String appBarTitle;
  const MenuDrawer({
    super.key,
    required this.appBarTitle,
  });

  @override
  Widget build(BuildContext context) {
    final productListNotifier = Provider.of<ProductsListNotifier>(context);
    final List<String> list = productListNotifier.productsListNotifier;
    final theme = Theme.of(context).textTheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(color: second2),
            child: ClipRect(
              child: Stack(
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: CustomImageWidget(
                        //TODO CHANGE THIS URL FOR OTHER BUSINESS
                        imageUrl:
                            'https://lsohakpxtnsjxexmvdmj.supabase.co/storage/v1/object/public/business/menu_drawer.png',
                      )),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          spreadRadius: 10,
                          blurRadius: 10,
                        )
                      ]),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: white),
                          'Menú',
                        ),
                      ),
                    ),
                  ),
                  _changeImageButton(context)
                ],
              ),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.store),
              title: getTexts('Inicio', theme.labelLarge),
              onTap: () {
                if (!appBarTitle.contains('Inicio')) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                    (route) => false,
                  );
                } else {
                  Navigator.pop(context);
                }
              }),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            endIndent: 5,
            indent: 5,
            height: 0,
          ),
          ...list.asMap().entries.map((entry) {
            String name = entry.value;
            return Column(children: [
              ListTile(
                leading: const Icon(Icons.local_mall_outlined),
                title: getTexts(name, theme.labelLarge),
                onTap: () {
                  if (appBarTitle.contains('Inicio')) {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .pushNamed(name, arguments: {'name': name});
                  } else {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .pushReplacementNamed(name, arguments: {'name': name});
                  }
                },
              ),
            ]);
          }).toList(),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            endIndent: 5,
            indent: 5,
            height: 0,
          ),
          customFutureBuilder(
              child: ListTile(
                  leading: const Icon(Icons.business_center_outlined),
                  title: getTexts('Gestiòn del Negocio', theme.labelLarge),
                  onTap: () {
                    if (!isAccountFinished(context)) return;
                    if (appBarTitle.contains('Inicio')) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const BusinessManagement(),
                      ));
                    } else {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const BusinessManagement(),
                      ));
                    }
                  })),
          ListTile(
              leading: const Icon(Icons.list_alt),
              title: getTexts('Pedidos', theme.labelLarge),
              onTap: () {
                if (!isAccountFinished(context)) return;
                if (appBarTitle.contains('Inicio')) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const OrdersScreen(),
                  ));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const OrdersScreen(),
                  ));
                }
              }),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            endIndent: 5,
            indent: 5,
            height: 0,
          ),
          ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: getTexts('Perfil', theme.labelLarge),
              onTap: () {
                if (appBarTitle.contains('Inicio')) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RedirectScreen(),
                  ));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const RedirectScreen(),
                  ));
                }
              }),
          ListTile(
              leading: const Icon(Icons.settings),
              title: getTexts('Configuraciones', theme.labelLarge),
              onTap: () {
                if (appBarTitle.contains('Inicio')) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ));
                }
              }),
        ],
      ),
    );
  }

  _changeImageButton(BuildContext context) {
    return customFutureBuilder(
      child: Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
            onPressed: () async {
              XFile? pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              File file;
              if (pickedFile != null) {
                try {
                  XFile compressedImage =
                      await compressImage(imageFile: pickedFile);
                    file = File.fromUri(Uri.parse(compressedImage.path));
                    await supabase.storage
                        .from('business')
                        .update('menu_drawer.png', file);
                } catch (e) {
                  throw e;
                }
              }
            },
            icon: Icon(Icons.image)),
      ),
    );
  }
}
