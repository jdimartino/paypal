require('dotenv').config();

const CLIENT_ID = process.env.PAYPAL_CLIENT_ID;
const CLIENT_SECRET = process.env.PAYPAL_CLIENT_SECRET;
const BASE_URL = process.env.PAYPAL_MODE === 'live'
    ? 'https://api-m.paypal.com'
    : 'https://api-m.sandbox.paypal.com';

async function getAccessToken() {
    if (!CLIENT_ID || !CLIENT_SECRET || CLIENT_ID.includes('your_client_id')) {
        throw new Error('Missing or default credentials in .env file');
    }

    const auth = Buffer.from(`${CLIENT_ID}:${CLIENT_SECRET}`).toString('base64');

    try {
        const response = await fetch(`${BASE_URL}/v1/oauth2/token`, {
            method: 'POST',
            body: 'grant_type=client_credentials',
            headers: {
                'Authorization': `Basic ${auth}`,
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        });

        if (!response.ok) {
            const error = await response.text();
            throw new Error(`Auth Failed: ${error}`);
        }

        const data = await response.json();
        return data.access_token;
    } catch (error) {
        console.error('Error getting access token:', error.message);
        process.exit(1);
    }
}

async function fetchTransactions() {
    console.log('Authenticating with PayPal...');
    const token = await getAccessToken();
    console.log('Authentication successful.');

    // Calculate dates (last 30 days)
    const end = new Date();
    const start = new Date();
    start.setDate(start.getDate() - 30);

    const startDate = start.toISOString();
    const endDate = end.toISOString();

    console.log(`Fetching transactions from ${startDate} to ${endDate}...`);

    try {
        const response = await fetch(`${BASE_URL}/v1/reporting/transactions?start_date=${startDate}&end_date=${endDate}&fields=all&page_size=100&transaction_status=S`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            const error = await response.text();
            throw new Error(`Fetch Failed: ${error}`);
        }

        const data = await response.json();
        const transactions = data.transaction_details;

        console.log(`Found ${transactions ? transactions.length : 0} transactions.`);

        if (transactions && transactions.length > 0) {
            console.log(JSON.stringify(transactions, null, 2));

            // TODO: Here we can save to file or process further
            const fs = require('fs');
            fs.writeFileSync('paypal-data.json', JSON.stringify(transactions, null, 2));
            console.log('Data saved to paypal-data.json');
        }

    } catch (error) {
        console.error('Error fetching transactions:', error.message);
    }
}

// Run the script
fetchTransactions();
