import 'package:easyrent/data/models/agent_model.dart';
import 'package:easyrent/presentation/views/search/widgets/Agent_search_card.dart';
import 'package:flutter/material.dart';

class AgentSearchFeed extends StatelessWidget {
  final List<Agent> agentList;

  const AgentSearchFeed({super.key, required this.agentList});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final agent = agentList[index];
          return AgentSearchCard(
            id: agent.id,
            name: agent.name,
            imageUrl: agent.photo,
          );
        },
        childCount: agentList.length,
      ),
    );
  }
}
