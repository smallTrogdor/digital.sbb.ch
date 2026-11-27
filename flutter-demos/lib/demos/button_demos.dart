import 'package:material_ui/material_ui.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';

/// Mirrors the variants on /design-system/mobile/components/button/.
/// Pressed is not a separate entry: press the Default button to see it.
final Map<String, WidgetBuilder> buttonDemos = {
  'button/primary': (_) => _StateRow(
    width: 200,
    button: (onPressed, isLoading) => SBBPrimaryButton(labelText: 'Label', onPressed: onPressed, isLoading: isLoading),
  ),
  'button/secondary': (_) => _StateRow(
    width: 200,
    button: (onPressed, isLoading) => SBBSecondaryButton(labelText: 'Label', onPressed: onPressed, isLoading: isLoading),
  ),
  'button/tertiary-label-and-icon': (_) => _StateRow(
    button: (onPressed, isLoading) => SBBTertiaryButton(
      labelText: 'Label',
      iconData: SBBIcons.dog_small,
      onPressed: onPressed,
      isLoading: isLoading,
    ),
  ),
  'button/tertiary-label': (_) => _StateRow(
    button: (onPressed, isLoading) => SBBTertiaryButton(labelText: 'Label', onPressed: onPressed, isLoading: isLoading),
  ),
  'button/tertiary-icon': (_) => _StateRow(
    button: (onPressed, isLoading) =>
        SBBTertiaryButton(iconData: SBBIcons.dog_small, onPressed: onPressed, isLoading: isLoading),
  ),
  'button/tertiary-small-label-and-icon': (_) => _StateRow(
    button: (onPressed, isLoading) => SBBTertiaryButtonSmall(
      labelText: 'Label',
      iconData: SBBIcons.dog_small,
      onPressed: onPressed,
      isLoading: isLoading,
    ),
  ),
  'button/tertiary-small-label': (_) => _StateRow(
    button: (onPressed, isLoading) =>
        SBBTertiaryButtonSmall(labelText: 'Label', onPressed: onPressed, isLoading: isLoading),
  ),
  'button/tertiary-small-icon': (_) => _StateRow(
    button: (onPressed, isLoading) =>
        SBBTertiaryButtonSmall(iconData: SBBIcons.dog_small, onPressed: onPressed, isLoading: isLoading),
  ),
};

typedef _ButtonBuilder = Widget Function(VoidCallback? onPressed, bool isLoading);

/// Shows one button in the states Default, Disabled and Loading, each with a caption.
class _StateRow extends StatelessWidget {
  const _StateRow({required this.button, this.width});

  final _ButtonBuilder button;

  /// Fixed width for full-width buttons. Tertiary buttons size to their content.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final captionColor = Theme.of(context).sbbBaseStyle.colorScheme.textSecondary;
    Widget state(String caption, Widget child) => Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      spacing: SBBSpacing.xSmall,
      children: [
        Text(caption, style: sbbTextStyle.small.copyWith(color: captionColor)),
        SizedBox(width: width, child: child),
      ],
    );

    return Center(
      child: SingleChildScrollView(
        scrollDirection: .horizontal,
        padding: const .all(SBBSpacing.xSmall),
        child: Row(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          spacing: SBBSpacing.large,
          children: [
            state('Default', button(() {}, false)),
            state('Disabled', button(null, false)),
            state('Loading', button(() {}, true)),
          ],
        ),
      ),
    );
  }
}
