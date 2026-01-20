/**
 * LaunchPad Data Source Testing Script
 * Tests all API endpoints and generates a report
 */

const SUPABASE_URL = 'https://hproaphyfhtfkxoeslag.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhwcm9hcGh5Zmh0Zmt4b2VzbGFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg4ODc2MjgsImV4cCI6MjA4NDQ2MzYyOH0.RVYTCPBA9LG75Z4N9FIRIjxsP4dS8gjVWaFdUWFr_aM';

const results = {
    timestamp: new Date().toISOString(),
    sources: {},
    summary: {
        totalApis: 0,
        working: 0,
        failed: 0,
        totalOpportunities: 0,
        liveData: 0,
        fallbackData: 0
    }
};

// Helper function to test API
async function testAPI(name, testFn) {
    console.log(`\n🔍 Testing ${name}...`);
    results.sources[name] = { status: 'testing' };

    try {
        const result = await testFn();
        results.sources[name] = {
            status: 'success',
            count: result.count || 0,
            details: result.details || 'OK',
            sampleData: result.sample || null
        };
        results.summary.working++;
        results.summary.totalOpportunities += (result.count || 0);
        results.summary.liveData += (result.count || 0);
        console.log(`✅ ${name}: SUCCESS (${result.count || 0} opportunities)`);
        return true;
    } catch (error) {
        results.sources[name] = {
            status: 'failed',
            error: error.message,
            count: 0
        };
        results.summary.failed++;
        console.log(`❌ ${name}: FAILED - ${error.message}`);
        return false;
    }
}

// Test 1: Codeforces API
async function testCodeforces() {
    const response = await fetch('https://codeforces.com/api/contest.list?gym=false');

    if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
    }

    const data = await response.json();

    if (data.status !== 'OK' || !data.result) {
        throw new Error('Invalid response format');
    }

    const upcoming = data.result.filter(c =>
        c.phase === 'BEFORE' && new Date(c.startTimeSeconds * 1000) > new Date()
    );

    return {
        count: Math.min(upcoming.length, 10),
        details: `${upcoming.length} upcoming contests found, displaying top 10`,
        sample: upcoming[0] ? {
            name: upcoming[0].name,
            startTime: new Date(upcoming[0].startTimeSeconds * 1000).toISOString()
        } : null
    };
}

// Test 2: Kontests API
async function testKontests() {
    const response = await fetch('https://kontests.net/api/v1/all');

    if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
    }

    const data = await response.json();

    if (!Array.isArray(data)) {
        throw new Error('Invalid response format');
    }

    const upcoming = data.filter(c =>
        c.status === 'BEFORE' || new Date(c.start_time) > new Date()
    );

    return {
        count: Math.min(upcoming.length, 15),
        details: `${upcoming.length} upcoming contests from multiple platforms`,
        sample: upcoming[0] ? {
            name: upcoming[0].name,
            site: upcoming[0].site,
            startTime: upcoming[0].start_time
        } : null
    };
}

// Test 3: Supabase Database
async function testSupabaseDB() {
    const response = await fetch(
        `${SUPABASE_URL}/rest/v1/opportunities?is_active=eq.true&order=deadline.asc&select=*`,
        {
            headers: {
                'apikey': SUPABASE_ANON_KEY,
                'Authorization': `Bearer ${SUPABASE_ANON_KEY}`
            }
        }
    );

    if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
    }

    const data = await response.json();

    if (!Array.isArray(data)) {
        throw new Error('Invalid response format');
    }

    const futureOpps = data.filter(opp => new Date(opp.deadline) >= new Date());

    return {
        count: futureOpps.length,
        details: `${futureOpps.length} opportunities in database (${data.length} total)`,
        sample: futureOpps[0] ? {
            title: futureOpps[0].title,
            type: futureOpps[0].type,
            organization: futureOpps[0].organization
        } : null
    };
}

// Test 4: Supabase Edge Function
async function testEdgeFunction() {
    const response = await fetch(
        `${SUPABASE_URL}/functions/v1/fetch-opportunities`,
        {
            method: 'POST',
            headers: {
                'apikey': SUPABASE_ANON_KEY,
                'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        }
    );

    if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
    }

    const data = await response.json();

    if (!data.success || !data.data) {
        throw new Error('Edge function returned error');
    }

    return {
        count: data.data.length,
        details: `Edge function returned ${data.data.length} opportunities`,
        sample: data.data[0] ? {
            title: data.data[0].title,
            type: data.data[0].type,
            source: data.data[0].source
        } : null
    };
}

// Count hardcoded opportunities
function countHardcodedData() {
    // From useOpportunities.tsx analysis
    const hardcodedCounts = {
        'Curated Hackathons': 7,
        'Curated Internships': 4,
        'Indian Opportunities': 40,
        'Weekly Contests': 10,
        'Community Events': 8
    };

    const total = Object.values(hardcodedCounts).reduce((sum, count) => sum + count, 0);

    results.sources['Hardcoded Fallback Data'] = {
        status: 'always_available',
        count: total,
        details: hardcodedCounts,
        note: 'This data is always shown if APIs fail or as supplementary data'
    };

    results.summary.fallbackData = total;
    console.log(`\n📚 Hardcoded Fallback: ${total} opportunities always available`);

    return total;
}

// Main test execution
async function runTests() {
    console.log('═══════════════════════════════════════════════════════');
    console.log('   LaunchPad Data Source Testing Report');
    console.log('═══════════════════════════════════════════════════════');
    console.log(`Started at: ${new Date().toLocaleString()}`);

    // Test each source
    await testAPI('Codeforces API', testCodeforces);
    await testAPI('Kontests API', testKontests);
    await testAPI('Supabase Database', testSupabaseDB);
    await testAPI('Supabase Edge Function', testEdgeFunction);

    // Count hardcoded data
    countHardcodedData();

    // Calculate totals
    results.summary.totalApis = 4; // Codeforces, Kontests, DB, Edge Function

    // Generate report
    console.log('\n═══════════════════════════════════════════════════════');
    console.log('   SUMMARY REPORT');
    console.log('═══════════════════════════════════════════════════════');
    console.log(`\n📊 API Status:`);
    console.log(`   Working: ${results.summary.working}/${results.summary.totalApis}`);
    console.log(`   Failed:  ${results.summary.failed}/${results.summary.totalApis}`);
    console.log(`\n📈 Data Breakdown:`);
    console.log(`   Live API Data:      ${results.summary.liveData} opportunities`);
    console.log(`   Hardcoded Fallback: ${results.summary.fallbackData} opportunities`);
    console.log(`   Total Available:    ${results.summary.liveData + results.summary.fallbackData} opportunities`);

    const livePercentage = ((results.summary.liveData / (results.summary.liveData + results.summary.fallbackData)) * 100).toFixed(1);
    const fallbackPercentage = ((results.summary.fallbackData / (results.summary.liveData + results.summary.fallbackData)) * 100).toFixed(1);

    console.log(`\n📊 Data Composition:`);
    console.log(`   Live Data:    ${livePercentage}%`);
    console.log(`   Fallback:     ${fallbackPercentage}%`);

    console.log('\n═══════════════════════════════════════════════════════');
    console.log('   RECOMMENDATIONS');
    console.log('═══════════════════════════════════════════════════════\n');

    if (results.summary.working === results.summary.totalApis) {
        console.log('✅ All APIs working perfectly!');
        console.log('   Your users are getting fresh, live data.');
    } else if (results.summary.working >= 2) {
        console.log('⚠️  Some APIs failing, but enough are working.');
        console.log('   Users still get mix of live + curated data.');
    } else {
        console.log('🔴 Most APIs are failing!');
        console.log('   Users seeing mostly hardcoded data.');
        console.log('   Action: Check network, API keys, or CORS settings.');
    }

    console.log('\n═══════════════════════════════════════════════════════\n');

    // Save detailed results to file
    const fs = require('fs');
    fs.writeFileSync(
        'data-source-report.json',
        JSON.stringify(results, null, 2)
    );
    console.log('💾 Detailed report saved to: data-source-report.json\n');

    return results;
}

// Run the tests
runTests().catch(error => {
    console.error('Fatal error:', error);
    process.exit(1);
});
