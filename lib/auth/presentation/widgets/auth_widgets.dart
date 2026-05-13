import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';

// ── Route Logo ────────────────────────────────────────────────────────────────
class RouteLogo extends StatelessWidget {
  final double size;
  const RouteLogo({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(
            size: Size(size * 0.35, size * 0.8),
            painter: _BracketPainter(),
          ),
          const SizedBox(width: 4),
          Text(
            'Route',
            style: TextStyle(
              color: AppColors.white,
              fontSize: size * 0.75,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── App Input Field ───────────────────────────────────────────────────────────
class AppInputField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? hint;

  const AppInputField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.label),
          const SizedBox(height: 7),
          TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(color: AppColors.inputBg, fontSize: 14),
            decoration: InputDecoration(
              hintText: placeholder,
              suffixIcon: suffixIcon,
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 5),
            Text(
              hint!,
              style: const TextStyle(
                color: AppColors.placeholder,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Primary Button ────────────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading ? AppColors.placeholder : AppColors.white,
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              )
            : Text(label, style: AppTextStyles.buttonText),
      ),
    );
  }
}

// ── Error Banner ──────────────────────────────────────────────────────────────
class ErrorBanner extends StatelessWidget {
  final String message;
  const ErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.12),
        border: Border.all(color: AppColors.error.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.error, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ── Success Banner ────────────────────────────────────────────────────────────
class SuccessBanner extends StatelessWidget {
  final String message;
  const SuccessBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.12),
        border: Border.all(color: AppColors.success.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.success, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ── Back Button ───────────────────────────────────────────────────────────────
class AppBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AppBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.chevron_left_rounded,
                color: AppColors.label,
                size: 22,
              ),
              Text(
                'Back',
                style: TextStyle(color: AppColors.label, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
