import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:igreja_izau/controller/member_controller.dart';
import 'package:igreja_izau/mock/congregacao_mock.dart';
import 'package:igreja_izau/model/member.dart';
import 'package:igreja_izau/utils/connection.dart';
import 'package:igreja_izau/utils/variables.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'styles.dart';

class CadastrarMembro extends StatelessWidget {
  CadastrarMembro({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey();

  _save(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        Member newMember = Member(
          congregacao: dataOfNewMember['congregacao'] ?? '',
          cpf: dataOfNewMember['CPF'] ?? '',
          dataNascimento: dataOfNewMember['Nascido em'] ?? '',
          endereco: dataOfNewMember['Endereço'] ?? '',
          estado: dataOfNewMember['Estado'] ?? '',
          estadoCivil: dataOfNewMember['Estado Civil'] ?? '',
          filiacaoMae: dataOfNewMember['Filiação (mãe)'] ?? '',
          filiacaoPai: dataOfNewMember['e de (pai)'] ?? '',
          matriculaID: 0,
          nacionalidade: dataOfNewMember['Nacionalidade'] ?? '',
          name: dataOfNewMember['Nome'] ?? '',
          naturalidade: dataOfNewMember['Natural de'] ?? '',
          rg: dataOfNewMember['RG'] ?? '',
          conjuge: dataOfNewMember['Cônjuge'] ?? '',
          conjugeCargo: dataOfNewMember['Cargo'] ?? '',
          conjugeMatricula: dataOfNewMember['Nº Matr'] ?? 0,
          dataAdmissao: dataOfNewMember['Data Admissão'] ?? 0,
          dataBatismo: dataOfNewMember['Batizou-se em'] ?? 0,
          dataSaida: dataOfNewMember['Data Saída'] ?? 0,
          escolaridade: dataOfNewMember['Escolaridade'] ?? '',
          igrejaBatismo: dataOfNewMember['Igreja/Local'] ?? '',
          imagemURL: '',
          membroIgreja: dataOfNewMember['Membro Igreja'] ?? false,
          numeroCertidao: dataOfNewMember['Número'] ?? '',
          observacao: '',
          procedencia: dataOfNewMember['Procedência'] ?? '',
          profissao: dataOfNewMember['Profissão'] ?? '',
          tipoCertidao: dataOfNewMember['Certidão de'] ?? '',
          tituloEleitor: dataOfNewMember['Tit. Eleitor'] ?? '',
        );

        var body = newMember.toJson();

        Uri url = Uri.https(host, addPath);
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response.body.toString()),
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response.body.toString()),
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.red,
          ));
        }

        dataOfNewMember.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro: ' + e.toString()),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Header(),
            const Divider(),
            const Formulario(),
            const Divider(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton(
                onPressed: () => _save(context),
                child: const Text('ENVIAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  Header({Key? key}) : super(key: key);

  final MemberController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(flex: 1, child: Image.asset('assets/images/logo-empty.png')),
          const Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'IGREJA EVANGÉLICA ASSEMBLÉIA DE DEUS\nFICHA DE CADASTRAMENTO - A.D.P.F',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Column(
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SizedBox(
                      width: 90,
                      child: Text('Matrícula'),
                    ),
                    SizedBox(
                      width: 180,
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 90,
                        margin: const EdgeInsets.only(right: 10),
                        child: const Text(
                          'Congregação:',
                        )),
                    Obx(
                      () => SizedBox(
                        width: 180,
                        child: DropdownButton<String>(
                            underline: Container(),
                            value: controller.congregacao,
                            onChanged: (value) {
                              controller.congregacao = value!;
                              dataOfNewMember["congregacao"] = value;
                            },
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            alignment: Alignment.center,
                            items: congregacoes
                                .map((value) => DropdownMenuItem(
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      value: value,
                                    ))
                                .toList()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Formulario extends StatelessWidget {
  const Formulario({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(top: 10, right: 8),
                  decoration: BoxDecoration(border: Border.all()),
                  child: _fields(context),
                ),
              ),
              SizedBox(
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: GetBuilder<MemberController>(
                        builder: (controller) => Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(border: Border.all()),
                          height: 150,
                          child: GestureDetector(
                            child: Center(
                              child: controller.child,
                            ),
                            onTap: () async {
                              Image? result =
                                  await ImagePickerWeb.getImageAsWidget();

                              if (result != null) {
                                controller.loadImage(result.image);
                              } else {
                                controller.child = const Placeholder();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    GetX<MemberController>(
                      builder: (controller) => Container(
                        width: 200,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: controller.memberStatus == MemberStatus.ativo
                              ? Colors.green[200]
                              : Colors.red[200],
                        ),
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Center(
                              child: Text(
                                'STATUS',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Center(
                              child: Text(
                                controller.memberStatus == MemberStatus.ativo
                                    ? 'ATIVO'
                                    : 'INATIVO',
                                style: const TextStyle(
                                  fontSize: 30,
                                  letterSpacing: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all()),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      width: 250,
                      child: Column(
                        children: [
                          const Text('CÓDIGO'),
                          GetX<MemberController>(
                            builder: (controller) => Column(
                              children: [
                                DropdownButton(
                                  value: controller.codigo,
                                  items: codigos.entries
                                      .map((e) => DropdownMenuItem(
                                          value: e.key,
                                          child: Text(e.key.toString() +
                                              ": " +
                                              e.value['definicao']!)))
                                      .toList(),
                                  onChanged: (value) =>
                                      controller.codigo = value as int,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 20,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                        codigos[controller.codigo]!['descricao']
                                            .toString()),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      int codigoSelecionado = controller.codigo;
                                      String? definicao = codigos[
                                          codigoSelecionado]!['definicao'];
                                      if (definicao != null) {
                                        dataOfNewMember['historico'] = {
                                          codigoSelecionado.toString():
                                              definicao
                                        };

                                        dataOfNewMember['historico']
                                            .forEach((key, value) {
                                          historicoController.text +=
                                              key + ': ' + value + '\n';
                                        });
                                      }
                                    },
                                    child: const Text('Incluir'),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue[600]))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Historico(),
        ],
      ),
    ));
  }

  _fields(BuildContext context) => Column(
        children: [
          fieldTextStyle(name: 'Nome', validate: true),
          fieldTextStyle(name: 'Filiação (mãe)', validate: true),
          fieldTextStyle(name: 'e de (pai)', validate: true),
          Row(
            children: [
              Expanded(
                child: fieldDataStyle(
                    name: 'Nascido em',
                    context: context,
                    validate: true,
                    controller: dataNascimento),
              ),
              Expanded(
                child: fieldTextStyle(name: 'Nacionalidade', validate: true),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: fieldTextStyle(name: 'Natural de', validate: true),
              ),
              Expanded(
                child: fieldTextStyle(name: 'Estado', validate: true),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: fieldTextStyle(name: 'Estado Civil', validate: true),
              ),
              Expanded(
                child: fieldTextStyle(name: 'Profissão'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: fieldTextStyle(name: 'Escolaridade'),
              ),
              Expanded(
                child: fieldTextStyle(name: 'Tit. Eleitor'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: fieldTextStyle(name: 'Certidão de'),
              ),
              Expanded(
                child: fieldTextStyle(name: 'Número'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: fieldDataStyle(
                    name: 'Batizou-se em',
                    context: context,
                    controller: dataBatismo),
              ),
              Expanded(
                child: fieldTextStyle(name: 'Igreja/Local'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: fieldDataStyle(
                    name: 'Data Admissão',
                    context: context,
                    controller: dataAdmissao),
              ),
              Expanded(
                child: fieldTextStyle(name: 'RG', validate: true),
              ),
              Expanded(
                child: fieldTextStyle(name: 'CPF', validate: true),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: fieldTextStyle(name: 'Cônjuge'),
              ),
              Expanded(
                child: fieldTextStyle(name: 'Nº Matr'),
              ),
            ],
          ),
          fieldTextStyle(name: 'Cargo'),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        const Text('Já foi membro desta igreja?'),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: GetX<MemberController>(
                              builder: (controller) => Row(
                                children: [
                                  Radio<String>(
                                      value: 'S',
                                      groupValue: controller.radio,
                                      onChanged: (value) {
                                        dataOfNewMember['Membro Igreja'] = true;
                                        controller.radio = value!;
                                      }),
                                  const Text('SIM'),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Radio<String>(
                                    value: 'N',
                                    groupValue: controller.radio,
                                    onChanged: (value) {
                                      controller.radio = value!;
                                      dataOfNewMember['Membro Igreja'] = false;
                                    },
                                  ),
                                  const Text('NÃO'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: fieldDataStyle(
                    name: 'Data Saída',
                    context: context,
                    controller: dataSaida),
              ),
            ],
          ),
          fieldTextStyle(name: 'Procedência'),
          fieldTextStyle(name: 'Endereço', validate: true),
        ],
      );
}

class Historico extends StatelessWidget {
  Historico({Key? key}) : super(key: key);

  final GlobalKey<FormState> historicKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: const Center(
              child: Text(
                'HISTÓRICO',
                style: TextStyle(letterSpacing: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Form(
              key: historicKey,
              child: TextFormField(
                onSaved: (newValue) {
                  print(newValue);
                },
                controller: historicoController,
                maxLines: null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
/*               TextButton(
                              onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                      builder: (context, setState) =>
                                          AlertDialog(
                                        title: const Text(
                                            'Deseja realmente alterar\no status do membro?'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                    text: 'Status atual: ',
                                                    children: [
                                                      TextSpan(
                                                        text: controller
                                                            .memberStatusToString,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: controller
                                                                        .memberStatus ==
                                                                    MemberStatus
                                                                        .ativo
                                                                ? Colors.green
                                                                : Colors.red),
                                                      ),
                                                    ]),
                                              ),
                                              const Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                    text: 'Novo status: ',
                                                    children: [
                                                      TextSpan(
                                                        text: controller
                                                                    .memberStatus ==
                                                                MemberStatus
                                                                    .ativo
                                                            ? 'INATIVO'
                                                            : 'ATIVO',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: controller
                                                                        .memberStatus ==
                                                                    MemberStatus
                                                                        .ativo
                                                                ? Colors.red
                                                                : Colors.green),
                                                      ),
                                                    ]),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text('Motivo: '),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  DropdownButton(
                                                    value: controller.codigo,
                                                    items: codigos.entries
                                                        .map((e) => DropdownMenuItem(
                                                            value: e.key,
                                                            child: Text(e.key
                                                                    .toString() +
                                                                ": " +
                                                                e.value[
                                                                    'definicao']!)))
                                                        .toList(),
                                                    onChanged: (value) =>
                                                        setState(
                                                      () => controller.codigo =
                                                          value as int,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () => '',
                                            child: const Text('Confirmar'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              child: const Text('Alterar Status'))
             */