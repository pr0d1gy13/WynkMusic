import 'package:flutter/material.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Upgrade Paywall', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage('https://placehold.co/100x100/3498db/ffffff/png?text=A'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            // Header Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.stars, color: Color(0xFFE53935), size: 48),
            ),
            const SizedBox(height: 24),
            
            // Texts
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('UPGRADE EXPERIENCE', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Listen without limits.',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Enjoy uninterrupted, master-quality music\nacross all your devices.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[400], height: 1.4),
            ),
            const SizedBox(height: 32),

            // Wynk Premium Card
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Wynk Premium', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: '₹99 ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                                TextSpan(text: '/mo', style: TextStyle(fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Solo uninterrupted listening', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                      const SizedBox(height: 20),
                      _buildCheckListItem('Ad-free listening (Zero interruptions)', true),
                      _buildCheckListItem('Unlimited song skips', true),
                      _buildCheckListItem('HD Audio streaming & downloads (320kbps)', true),
                      _buildCheckListItem('Offline downloads on up to 3 devices', true),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Get Wynk Premium', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -12,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('BEST VALUE • RECOMMENDED', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Family Plan Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(text: 'Family Plan ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            TextSpan(text: 'Up to 6 accounts', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(text: '₹149 ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                            TextSpan(text: '/mo', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Independent profiles for each member', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                  const SizedBox(height: 16),
                  _buildCheckListItem('6 individual premium accounts', false),
                  _buildCheckListItem('Separate recommendations & liked songs', false),
                  _buildCheckListItem('Ad-free & HD audio for the whole household', false),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withAlpha(15),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Choose Family Plan', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Airtel Exclusive Benefit Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('AIRTEL EXCLUSIVE BENEFIT', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.sim_card, color: Colors.red, size: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Airtel User?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                            const SizedBox(height: 4),
                            Text('Included free with\n₹299+ prepaid plans', style: TextStyle(color: Colors.grey[400], fontSize: 14, height: 1.3)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.security, size: 16, color: Colors.white),
                      label: const Text('Activate Free Benefit', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withAlpha(15),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text('Terms apply. Auto-renews with active recharge.', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100), // padding for mini player
          ],
        ),
      ),
    );
  }

  Widget _buildCheckListItem(String text, bool isGreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 18, color: isGreen ? const Color(0xFF4CAF50) : Colors.grey[500]),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(color: Colors.grey[300], fontSize: 13, height: 1.3))),
        ],
      ),
    );
  }
}
