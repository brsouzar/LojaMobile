
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user_bloc.dart';
import '../tiles/user_tile.dart';

class UsersTab extends StatelessWidget {
   const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {

    final _userBloc = BlocProvider.of<UserBloc>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Pesquisar',
              hintStyle: TextStyle(color: Colors.white),
              icon: Icon(Icons.search, color: Colors.white),
              border: InputBorder.none
            ),
            onChanged: _userBloc.onChangedSearch
          ),
        ),
        Expanded(
            child: StreamBuilder<List>(
              stream: _userBloc.outUsers,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                  ),);
                }
                else if (snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum usário encontrado', style: TextStyle(color: Colors.pinkAccent),),);
                }
                else {
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      return UserTile(snapshot.data![index]);
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: snapshot.data!.length,
                  );
                }
              }
            ),
        ),
      ],
    );
  }
}
