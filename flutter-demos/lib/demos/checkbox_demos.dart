import 'package:material_ui/material_ui.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';

/// Mirrors the variants on /design-system/mobile/components/checkbox/.
final Map<String, WidgetBuilder> checkboxDemos = {
  'checkbox/default': (_) => const _CheckboxStates(),
};

/// Selected, Unselected and Indeterminate, enabled in the first row and disabled in the second.
/// The enabled checkboxes can be toggled.
class _CheckboxStates extends StatelessWidget {
  const _CheckboxStates();

  static const _values = <(String, bool?)>[('Selected', true), ('Unselected', false), ('Indeterminate', null)];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: .horizontal,
        padding: const .all(SBBSpacing.xSmall),
        child: Column(
          mainAxisSize: .min,
          spacing: SBBSpacing.medium,
          children: [
            for (final enabled in [true, false])
              Row(
                mainAxisSize: .min,
                spacing: SBBSpacing.large,
                children: [
                  for (final (caption, value) in _values)
                    _LabeledCheckbox(
                      caption: enabled ? caption : '$caption disabled',
                      initialValue: value,
                      enabled: enabled,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _LabeledCheckbox extends StatefulWidget {
  const _LabeledCheckbox({required this.caption, required this.initialValue, required this.enabled});

  final String caption;
  final bool? initialValue;
  final bool enabled;

  @override
  State<_LabeledCheckbox> createState() => _LabeledCheckboxState();
}

class _LabeledCheckboxState extends State<_LabeledCheckbox> {
  late bool? _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    final captionColor = Theme.of(context).sbbBaseStyle.colorScheme.textSecondary;
    return SizedBox(
      width: 180,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        spacing: SBBSpacing.xxSmall,
        children: [
          Text(widget.caption, style: sbbTextStyle.small.copyWith(color: captionColor)),
          Row(
            children: [
              SBBCheckbox(
                value: _value,
                tristate: true,
                onChanged: widget.enabled ? (value) => setState(() => _value = value) : null,
              ),
              Text('Label', style: widget.enabled ? null : TextStyle(color: captionColor)),
            ],
          ),
        ],
      ),
    );
  }
}
