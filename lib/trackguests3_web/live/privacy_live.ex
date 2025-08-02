defmodule Trackguests3Web.PrivacyLive do
  use Trackguests3Web, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Privacy Policy", current_scope: nil)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Header -->
        <div class="page-header-luxury">
          <h1 class="page-title-luxury">Privacy Policy</h1>
          <p class="page-subtitle-luxury">
            Your privacy and data security are our top priorities
          </p>
          <p class="text-sm text-gray-500 mt-2">
            Last updated: <%= Date.utc_today() |> Calendar.strftime("%B %d, %Y") %>
          </p>
        </div>

        <!-- Content -->
        <div class="prose prose-lg max-w-none">
          <div class="card-luxury space-y-8">
            <!-- Data Confidentiality -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">Data Confidentiality</h2>
              <div class="bg-green-50 border border-green-200 rounded-xl p-6 mb-6">
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-green-600 mt-1 mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.707-1.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L9 10.586l7.293-7.293a1 1 0 011.414 0z"/>
                  </svg>
                  <div>
                    <h3 class="text-lg font-semibold text-green-800 mb-2">All Data is Confidential</h3>
                    <p class="text-green-700">
                      <strong>We treat all information collected through TrackGuest as strictly confidential.</strong>
                      Your guest data, personal information, and usage patterns are never shared, sold, or disclosed to third parties without your explicit consent.
                    </p>
                  </div>
                </div>
              </div>
              
              <p class="text-gray-700 leading-relaxed">
                TrackGuest is designed as a private guest management system. We understand that visitor information
                and property management data is sensitive and personal. Our commitment to confidentiality means:
              </p>
              
              <ul class="list-disc pl-6 mt-4 space-y-2 text-gray-700">
                <li>Guest check-in and check-out information remains private to your account</li>
                <li>Visitor personal details are encrypted and stored securely</li>
                <li>Property information and room assignments are confidential</li>
                <li>We do not analyze, mine, or use your data for commercial purposes</li>
                <li>No advertising or marketing based on your guest data</li>
              </ul>
            </section>

            <!-- Information We Collect -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">Information We Collect</h2>
              
              <div class="space-y-4">
                <div>
                  <h3 class="text-lg font-semibold text-gray-800 mb-2">Account Information</h3>
                  <p class="text-gray-700">When you create an account, we collect your email address and basic profile information for authentication and account management.</p>
                </div>
                
                <div>
                  <h3 class="text-lg font-semibold text-gray-800 mb-2">Guest Management Data</h3>
                  <p class="text-gray-700">Information you enter about guests including names, contact details, visit purposes, and room assignments. This data is stored securely and remains under your control.</p>
                </div>
                
                <div>
                  <h3 class="text-lg font-semibold text-gray-800 mb-2">Property Information</h3>
                  <p class="text-gray-700">Details about your properties, rooms, and facilities that you choose to manage through our system.</p>
                </div>
              </div>
            </section>

            <!-- How We Use Information -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">How We Use Your Information</h2>
              
              <p class="text-gray-700 mb-4">We use your information solely to:</p>
              
              <ul class="list-disc pl-6 space-y-2 text-gray-700">
                <li>Provide guest management and tracking services</li>
                <li>Maintain your account and preferences</li>
                <li>Ensure system security and prevent unauthorized access</li>
                <li>Provide customer support when requested</li>
                <li>Improve our service functionality (using anonymized, aggregated data only)</li>
              </ul>
              
              <div class="bg-blue-50 border border-blue-200 rounded-xl p-6 mt-6">
                <p class="text-blue-800">
                  <strong>We never:</strong> Share your data with third parties, use your data for advertising, 
                  sell your information, or access your guest data unless specifically requested for support.
                </p>
              </div>
            </section>

            <!-- Data Security -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">Data Security</h2>
              
              <p class="text-gray-700 mb-4">We implement industry-standard security measures:</p>
              
              <ul class="list-disc pl-6 space-y-2 text-gray-700">
                <li>Encrypted data transmission (HTTPS/TLS)</li>
                <li>Secure database storage with encryption at rest</li>
                <li>Regular security updates and monitoring</li>
                <li>Access controls and authentication measures</li>
                <li>Regular backups to prevent data loss</li>
              </ul>
            </section>

            <!-- Your Rights -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">Your Rights</h2>
              
              <p class="text-gray-700 mb-4">You have complete control over your data:</p>
              
              <ul class="list-disc pl-6 space-y-2 text-gray-700">
                <li><strong>Access:</strong> View all data we have about you</li>
                <li><strong>Correction:</strong> Update or correct your information</li>
                <li><strong>Deletion:</strong> Request deletion of your account and all associated data</li>
                <li><strong>Export:</strong> Download your data in a portable format</li>
                <li><strong>Restriction:</strong> Limit how we process your data</li>
              </ul>
            </section>

            <!-- Contact Information -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">Contact Us</h2>
              
              <p class="text-gray-700 mb-4">
                If you have any questions about this Privacy Policy or how we handle your data, please contact us:
              </p>
              
              <div class="bg-gray-50 rounded-xl p-6">
                <p class="text-gray-700">
                  <strong>Email:</strong> <a href="mailto:privacy@trackguest.com" class="text-blue-600 hover:text-blue-800">privacy@trackguest.com</a><br>
                  <strong>Response Time:</strong> We respond to privacy inquiries within 48 hours
                </p>
              </div>
            </section>

            <!-- Updates -->
            <section>
              <h2 class="text-2xl font-bold text-platinum mb-4">Policy Updates</h2>
              
              <p class="text-gray-700">
                We may update this Privacy Policy from time to time. We will notify you of any significant changes 
                by email and prominently display the updated policy on our website. Your continued use of TrackGuest 
                after such modifications constitutes your acknowledgment and acceptance of the updated policy.
              </p>
            </section>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end