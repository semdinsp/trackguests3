defmodule Trackguests3Web.TermsOfServiceLive do
  use Trackguests3Web, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Terms of Service", current_scope: nil)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Header -->
        <div class="page-header-luxury">
          <h1 class="page-title-luxury">Terms of Service</h1>
          <p class="page-subtitle-luxury">
            Simple, clear terms for using TrackGuest
          </p>
          <p class="text-sm text-gray-500 mt-2">
            Last updated: <%= Date.utc_today() |> Calendar.strftime("%B %d, %Y") %>
          </p>
        </div>

        <!-- Content -->
        <div class="prose prose-lg max-w-none">
          <div class="card-luxury space-y-8">
            <!-- Data Confidentiality Highlight -->
            <section>
              <div class="bg-green-50 border border-green-200 rounded-xl p-6 mb-6">
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-green-600 mt-1 mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m0 0v2m0-2h2m-2 0H10m9-9a9 9 0 11-18 0 9 9 0 0118 0z"/>
                  </svg>
                  <div>
                    <h2 class="text-xl font-bold text-green-800 mb-2">Data Confidentiality Commitment</h2>
                    <p class="text-green-700">
                      <strong>All data stored in TrackGuest is strictly confidential.</strong>
                      We do not share, sell, or disclose your information to any third parties. 
                      Your guest data and property information remain completely private and under your control.
                    </p>
                  </div>
                </div>
              </div>
            </section>

            <!-- Acceptance of Terms -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">1. Acceptance of Terms</h2>
              <p class="text-gray-700 leading-relaxed">
                By accessing and using TrackGuest ("the Service"), you accept and agree to be bound by these Terms of Service. 
                If you do not agree to these terms, please do not use our service.
              </p>
            </section>

            <!-- Description of Service -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">2. Description of Service</h2>
              <p class="text-gray-700 leading-relaxed mb-4">
                TrackGuest is a guest management system that allows property owners and managers to:
              </p>
              <ul class="list-disc pl-6 space-y-2 text-gray-700">
                <li>Track guest check-ins and check-outs</li>
                <li>Manage visitor information and room assignments</li>
                <li>Generate reports and export guest data</li>
                <li>Maintain property and room information</li>
                <li>Provide multi-language support for international guests</li>
              </ul>
            </section>

            <!-- User Responsibilities -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">3. User Responsibilities</h2>
              
              <div class="space-y-4">
                <div>
                  <h3 class="text-lg font-semibold text-gray-800 mb-2">Account Security</h3>
                  <p class="text-gray-700">You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.</p>
                </div>
                
                <div>
                  <h3 class="text-lg font-semibold text-gray-800 mb-2">Lawful Use</h3>
                  <p class="text-gray-700">You agree to use TrackGuest only for lawful purposes and in accordance with these Terms of Service.</p>
                </div>
                
                <div>
                  <h3 class="text-lg font-semibold text-gray-800 mb-2">Data Accuracy</h3>
                  <p class="text-gray-700">You are responsible for the accuracy and legality of any guest information you enter into the system.</p>
                </div>
                
                <div>
                  <h3 class="text-lg font-semibold text-gray-800 mb-2">Guest Consent</h3>
                  <p class="text-gray-700">You must obtain appropriate consent from guests before collecting and storing their personal information in TrackGuest.</p>
                </div>
              </div>
            </section>

            <!-- Data and Privacy -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">4. Data and Privacy</h2>
              
              <div class="bg-blue-50 border border-blue-200 rounded-xl p-6 mb-4">
                <h3 class="text-lg font-semibold text-blue-800 mb-2">Confidentiality Guarantee</h3>
                <p class="text-blue-700">
                  All data you store in TrackGuest is treated as strictly confidential. We do not access, analyze, 
                  share, or use your data for any purpose other than providing the service to you.
                </p>
              </div>
              
              <ul class="list-disc pl-6 space-y-2 text-gray-700">
                <li>Your guest data remains your property</li>
                <li>We implement industry-standard security measures to protect your information</li>
                <li>You can export or delete your data at any time</li>
                <li>We comply with applicable data protection regulations</li>
                <li>Detailed privacy practices are outlined in our <a href="/privacy" class="text-blue-600 hover:text-blue-800">Privacy Policy</a></li>
              </ul>
            </section>

            <!-- Service Availability -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">5. Service Availability</h2>
              <p class="text-gray-700 leading-relaxed">
                We strive to maintain high service availability, but we do not guarantee uninterrupted access to TrackGuest. 
                We may perform maintenance, updates, or experience technical issues that temporarily affect service availability.
              </p>
            </section>

            <!-- Prohibited Uses -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">6. Prohibited Uses</h2>
              
              <p class="text-gray-700 mb-4">You may not use TrackGuest to:</p>
              
              <ul class="list-disc pl-6 space-y-2 text-gray-700">
                <li>Store or transmit illegal, harmful, or offensive content</li>
                <li>Violate any applicable laws or regulations</li>
                <li>Infringe on intellectual property rights of others</li>
                <li>Attempt to gain unauthorized access to our systems</li>
                <li>Interfere with the proper functioning of the service</li>
                <li>Use the service for any commercial purpose without authorization</li>
              </ul>
            </section>

            <!-- Intellectual Property -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">7. Intellectual Property</h2>
              <p class="text-gray-700 leading-relaxed">
                TrackGuest and its original content, features, and functionality are owned by us and are protected by 
                international copyright, trademark, and other intellectual property laws. Your guest data remains your property.
              </p>
            </section>

            <!-- Limitation of Liability -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">8. Limitation of Liability</h2>
              <p class="text-gray-700 leading-relaxed">
                TrackGuest is provided "as is" without warranties of any kind. We shall not be liable for any indirect, 
                incidental, special, or consequential damages arising from your use of the service.
              </p>
            </section>

            <!-- Termination -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">9. Termination</h2>
              <p class="text-gray-700 leading-relaxed mb-4">
                Either party may terminate this agreement at any time:
              </p>
              <ul class="list-disc pl-6 space-y-2 text-gray-700">
                <li>You may delete your account and stop using the service at any time</li>
                <li>We may terminate accounts that violate these terms</li>
                <li>Upon termination, your data will be deleted according to our data retention policy</li>
                <li>You may export your data before termination</li>
              </ul>
            </section>

            <!-- Changes to Terms -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">10. Changes to Terms</h2>
              <p class="text-gray-700 leading-relaxed">
                We may update these Terms of Service from time to time. We will notify you of any material changes 
                by email and by posting the updated terms on our website. Your continued use of TrackGuest after 
                such modifications constitutes your acceptance of the updated terms.
              </p>
            </section>

            <!-- Governing Law -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">11. Governing Law</h2>
              <p class="text-gray-700 leading-relaxed">
                These Terms of Service shall be governed by and construed in accordance with applicable laws, 
                without regard to conflict of law principles.
              </p>
            </section>

            <!-- Contact Information -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">12. Contact Information</h2>
              
              <p class="text-gray-700 mb-4">
                If you have any questions about these Terms of Service, please contact us:
              </p>
              
              <div class="bg-gray-50 rounded-xl p-6">
                <p class="text-gray-700">
                  <strong>Email:</strong> <a href="mailto:legal@trackguest.com" class="text-blue-600 hover:text-blue-800">legal@trackguest.com</a><br>
                  <strong>Response Time:</strong> We respond to legal inquiries within 48 hours
                </p>
              </div>
            </section>

            <!-- Effective Date -->
            <section class="border-t border-gray-200 pt-6">
              <p class="text-sm text-gray-600">
                These Terms of Service are effective as of <%= Date.utc_today() |> Calendar.strftime("%B %d, %Y") %> 
                and supersede all prior agreements.
              </p>
            </section>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end