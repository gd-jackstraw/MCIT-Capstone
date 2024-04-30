/**
 * Configures a Google Firestore database resource.
 *
 * This resource creates a Firestore database instance in the specified project and location.
 * The database is configured to use the Firestore Native mode.
 */
resource "google_firestore_database" "database" {
  project     = "mcit-capstone-prod"
  name        = "prod-fire-db-data"
  location_id = "nam5"
  type        = "FIRESTORE_NATIVE"
}
