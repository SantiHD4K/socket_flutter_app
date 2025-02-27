import 'package:flutter/material.dart';

class ProviderPage extends StatefulWidget {
  const ProviderPage({super.key});

  static String routeName = 'ProviderPage';
  static String routePath = '/providerPage';

  @override
  State<ProviderPage> createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  late TextEditingController _textController;
  late FocusNode _textFieldFocusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFFF1F4F8),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF1F4F8),
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.black54,
                size: 40.0,
              ),
            ),
          ),
          title: const Text(
            'Proveedores',
            style: TextStyle(
              fontFamily: 'Outfit',
              color: Color(0xFF1D2429),
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        focusNode: _textFieldFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Buscar proveedor...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    IconButton(
                      icon:
                          Icon(Icons.search_rounded, color: Color(0xFF1D2429)),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Empresas',
                  style: TextStyle(color: Color(0xFF57636C), fontSize: 14.0),
                ),
              ),
              Container(
                height: 170.0,
                padding: EdgeInsets.only(left: 16.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(3, (index) => _buildCompanyCard()),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Vendedores',
                  style: TextStyle(color: Color(0xFF57636C), fontSize: 14.0),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) => _buildVendorTile(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard() {
    return Padding(
      padding: EdgeInsets.only(right: 12.0, top: 12.0, bottom: 12.0),
      child: Container(
        width: 160.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 4.0, color: Colors.black12, offset: Offset(0, 2))
          ],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
              ),
              radius: 30.0,
            ),
            SizedBox(height: 8.0),
            Text('Empresa X',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
            Text('Detalles',
                style: TextStyle(color: Color(0xFF57636C), fontSize: 12.0)),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorTile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 4.0, color: Colors.black12, offset: Offset(0, 2))
          ],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjJ8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
              ),
              radius: 18.0,
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vendedor Y',
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold)),
                  Text('user@correo.com',
                      style:
                          TextStyle(color: Color(0xFF57636C), fontSize: 12.0)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF126CD8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              child: Text('Ver',
                  style: TextStyle(color: Colors.white, fontSize: 14.0)),
            ),
          ],
        ),
      ),
    );
  }
}
