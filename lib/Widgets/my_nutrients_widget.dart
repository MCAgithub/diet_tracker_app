import 'package:flutter/material.dart';

class NutrientsWidget extends StatelessWidget {
  const NutrientsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          elevation: 4,
          //clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            height: 75,
            width: MediaQuery.of(context).size.width - 100,
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //const Spacer(),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Kulhydrater',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '0',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ],
                    ),
                  ),
                ),
                //const Spacer(),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Protein',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '0',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ],
                    ),
                  ),
                ),
                //const Spacer(),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Fedt',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '0',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ],
                    ),
                  ),
                ),
                //const Spacer(),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
