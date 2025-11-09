import React from 'react';
import { Box, H2, H5, Text, Illustration } from '@adminjs/design-system';

const Dashboard = () => {
  return (
    <Box>
      <Box mb="xxl">
        <Illustration variant="Planet" />
      </Box>
      <H2>Welcome to Jain Matrimony Admin Panel</H2>
      <Box mt="xl" mb="xl">
        <Text>
          Manage users, profiles, and matrimonial data from this centralized dashboard.
        </Text>
      </Box>

      <Box flexDirection="row" display="flex" justifyContent="space-between" flexWrap="wrap">
        <Box
          flex="1"
          minWidth="300px"
          bg="white"
          p="xl"
          m="lg"
          boxShadow="card"
          borderRadius="lg"
        >
          <H5>Users</H5>
          <Text>Manage registered users and their authentication</Text>
        </Box>

        <Box
          flex="1"
          minWidth="300px"
          bg="white"
          p="xl"
          m="lg"
          boxShadow="card"
          borderRadius="lg"
        >
          <H5>Profiles</H5>
          <Text>View and moderate matrimonial profiles</Text>
        </Box>
      </Box>

      <Box mt="xxl" p="lg" bg="primary100" borderRadius="lg">
        <Text fontSize="sm" color="grey80">
          <strong>Quick Tips:</strong>
          <ul>
            <li>Use filters to quickly find specific users or profiles</li>
            <li>Click on any record to view full details</li>
            <li>You can export data using the export button</li>
            <li>Profile status can be changed to moderate content</li>
          </ul>
        </Text>
      </Box>
    </Box>
  );
};

export default Dashboard;
